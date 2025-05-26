import 'dart:convert';
import 'dart:io';

import 'package:board_project/globals.dart';
import 'package:board_project/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../storage/local_stroage.dart';
import 'auth_service.dart';

class BoardService{

  static const String boardIp = "$ip/boards";
  late final AuthService authService;
  BoardService(this.authService);

  Future<List<Board>> getBoardList(int page, int size) async {
    final accessToken = await UserBox().getAccessToken();
    final url = Uri.parse("$boardIp?page=$page&size=$size");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    print("상태 확인 : ${response.statusCode}");
    print("리스폰스 체크 : ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> contentList = jsonBody['content'];
      return contentList.map((e) => Board.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      final newToken = await authService.refresh();
      if (newToken != null) {
        return getBoardList(page, size);
      } else {
        throw Exception('토큰 갱신 실패: 재로그인 필요');
      }
    } else {
      throw Exception('게시판 불러오기 실패: ${response.statusCode}');
    }
  }

  /*이미지 필수로 보내야함*/
  /*Future<int> createBoard(Board board, {File? image}) async {
    int id = 0;
    final accessToken = await UserBox().getAccessToken();
    final url = Uri.parse(boardIp);
    print('이미지 체크 $image');
    if (image == null)  {
      print('이미지 없는곳 진입');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": board.title,
          "content": board.content,
          "category": board.category,
        }),
      );
      print("상태 확인 : ${response.statusCode}");
      print("리스폰스 체크 : ${response.body}");
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        id = data['id'];
      } else if (response.statusCode == 401) {
        final newToken = await authService.refresh();
        if (newToken != null) {
          return createBoard(board, image: image);
        } else {
          throw Exception('토큰 갱신 실패: 재로그인 필요');
        }
      } else {
        throw Exception('게시글 등록 실패: ${response.statusCode}');
      }
    } else {
      print('이미지 있음');
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..files.add(http.MultipartFile.fromString(
          'request',
          jsonEncode({
            "title": board.title,
            "content": board.content,
            "category": board.category,
          }),
          contentType: MediaType('application', 'json'),
        ))
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("이미지 게시글 상태 확인 : ${response.statusCode}");
      print("이미지 게시글 응답 확인 : ${response.body}");
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        id = data['id'];
        return id;
      } else if (response.statusCode == 401) {
        final newToken = await authService.refresh();
        if (newToken != null) {
          return createBoard(board, image: image);
        } else {
          throw Exception('토큰 갱신 실패: 재로그인 필요');
        }
      } else {
        throw Exception('게시글 등록 실패: ${response.statusCode}');
      }
    }

    return id;
  }
*/


  Future<int> createBoard(Board board, {File? image}) async {
    int id = 0;
    final accessToken = await UserBox().getAccessToken();
    final url = Uri.parse(boardIp);

    print('이미지 체크: $image');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(http.MultipartFile.fromString(
        'request',
        jsonEncode({
          "title": board.title,
          "content": board.content,
          "category": board.category,
        }),
        contentType: MediaType('application', 'json'),
      ));
    final filePart = (image != null)
        ? await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType('image', 'jpeg'),
    )
        : http.MultipartFile.fromBytes(
      'file',
      [],
      filename: '',
      contentType: MediaType('application', 'octet-stream'),
    );

    request.files.add(filePart);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("상태 확인: ${response.statusCode}");
    print("응답 본문: ${response.body}");

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      id = data['id'];
    } else if (response.statusCode == 401) {
      final newToken = await authService.refresh();
      if (newToken != null) {
        return createBoard(board, image: image);
      } else {
        throw Exception('토큰 갱신 실패: 재로그인 필요');
      }
    } else {
      throw Exception('게시글 등록 실패: ${response.statusCode}');
    }
    return id;
  }
  Future<Board> getOneBoard(int boardId) async {
    final accessToken = await UserBox().getAccessToken();
    final url = Uri.parse("$boardIp/$boardId");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    print("상태 확인 : ${response.statusCode}");
    print("리스폰스 체크 : ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return Board.fromJson(jsonBody);
    } else if (response.statusCode == 401) {
      final newToken = await authService.refresh();
      if (newToken != null) {
        return getOneBoard(boardId);
      } else {
        throw Exception('토큰 갱신 실패: 재로그인 필요');
      }
    } else {
      throw Exception('게시판 불러오기 실패: ${response.statusCode}');
    }
  }

  Future<bool> deleteOneBoard(int boardId) async {
    final accessToken = await UserBox().getAccessToken();
    final url = Uri.parse("$boardIp/$boardId");

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    print("상태 확인 : ${response.statusCode}");
    print("리스폰스 체크 : ${response.body}");
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      final newToken = await authService.refresh();
      if (newToken != null) {
        return deleteOneBoard(boardId);
      } else {
        print("토큰 갱신 실패");
        return false;
      }
    } else {
      print("삭제 실패: ${response.statusCode}");
      return false;
    }
  }


  Future<bool> updateBoard(Board board, {File? image}) async {
    bool check = false;
    final accessToken = await UserBox().getAccessToken();
    final url = Uri.parse("$boardIp/${board.id}");
    final request = http.MultipartRequest('PATCH', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(http.MultipartFile.fromString(
        'request',
        jsonEncode({
          "title": board.title,
          "content": board.content,
          "category": board.category,
        }),
        contentType: MediaType('application', 'json'),
      ));
    final filePart = (image != null)
        ? await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType('image', 'jpeg'),
    )
        : http.MultipartFile.fromBytes(
      'file',
      [],
      filename: '',
      contentType: MediaType('application', 'octet-stream'),
    );

    request.files.add(filePart);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("상태 확인: ${response.statusCode}");
    print("응답 본문: ${response.body}");

    if (response.statusCode == 201) {

    } else if (response.statusCode == 401) {
      final newToken = await authService.refresh();
      if (newToken != null) {
        createBoard(board, image: image);
        return true;
      } else {
        throw Exception('토큰 갱신 실패: 재로그인 필요');
      }
    } else {
      throw Exception('게시글 등록 실패: ${response.statusCode}');
    }
    return false;
  }
}