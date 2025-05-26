import 'package:board_project/controllers/board_home_controller.dart';
import 'package:board_project/models/board.dart';
import 'package:board_project/service/board_service.dart';
import 'package:get/get.dart';
class BoardDetailController extends GetxController {
  final boardId = 0.obs;

  final BoardService boardService = Get.find<BoardService>();
  String errorText = '';
  Rxn<Board> board = Rxn<Board>();
  final isLoading = true.obs;
  /*내 게시글이 트루일경우 삭제 가져올떄 내 게시글인지? 없음*/
  RxBool myBoardCheck = false.obs;
  final BoardHomeController boardHomeController =  Get.find<BoardHomeController>();
  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments != null && Get.arguments['boardId'] != null) {
      boardId.value = Get.arguments['boardId'];
      await getBoard(boardId.value);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> getBoard(int boardId) async {
    try {
      final result = await boardService.getOneBoard(boardId);
      board.value = result;
    } catch (e) {
      board.value = null;
    } finally {
      isLoading.value = false;
    }
  }


  String getCategoryChangeKorean(String category) {
    switch (category) {
      case 'NOTICE':
        return '공지';
      case 'FREE':
        return '자유';
      case 'QNA':
        return 'Q&A';
      case 'ETC':
        return '기타';
      default:
        return '기타';
    }
  }

  String formatDate(String createdAt) {
    final dateTime = DateTime.parse(createdAt);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<bool> deleteBoard() async {
    final id = board.value?.id;
    if (id == null) {
      print("잘못된 접근");
      return false;
    }
    bool check = await boardService.deleteOneBoard(id);
    return check;
  }

  Future<void> updateBoardList() async{
    boardHomeController.fetchDataForTab(boardHomeController.categoryTab.value);
  }
}