import 'package:board_project/models/board.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../service/board_service.dart';

class BoardHomeController extends GetxController{
  final BoardService boardService = Get.find<BoardService>();
  RxInt currentTab = 0.obs;
  RxInt categoryTab = 0.obs;
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  int page=0;
  int size=10;

  RxList<Board> boardList = <Board>[].obs;
  final List<String> buttonLabels = [
    "전체","공지","자유","Q&A","기타"
  ];

  @override
  Future<void> onInit() async{
    super.onInit();
    scrollController.addListener(() {
      if (!isLoadingMore.value && scrollController.position.pixels > 600 * (page + 1)) {
        scrollAddPagingBoardList();
      }
    });
      await fetchDataForTab(categoryTab.value);

  }


  void changeTab(int index) {
    if(index == 0) {
      /*전체 게시글*/
      categoryTabChange(categoryTab.value);
    }else if(index == 1){
      /*인기글(미구현)*/
    }else{
      /*탭2번 나의 글목록 가져오기(미구현)*/
    }

    }

  void categoryTabChange(int index) {
    categoryTab.value = index;fetchDataForTab(index);
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

  Future<void> fetchDataForTab(int index) async {
    try {
      page = 0;
      hasMoreData.value = true;
      boardList.clear();

      final category = buttonLabels[index];
      final result = await boardService.getBoardList(page, size);

      boardList.addAll(result);
      if (result.length < size) {
        hasMoreData.value = false;
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  Future<void> refreshBoardList(int index) async {
    page = 0;
    hasMoreData.value = true;
    boardList.clear();
    try {
      final result = await boardService.getBoardList(page, size);
      boardList.addAll(result);
      if (result.length < size) {
        hasMoreData.value = false;
      }
    } catch (e) {
      print("새로고침 실패: $e");
    }
  }
  /*스크롤 페이징 */
  void scrollAddPagingBoardList() async {
    if (isLoadingMore.value || !hasMoreData.value) {
      return;
    }
    if( scrollController.position.pixels < 600 * (page + 1)) {
    return;
    }
    isLoadingMore.value = true;
    page += 1;
    try {
      final result = await boardService.getBoardList(page, size);

      if (result.isNotEmpty) {
        boardList.addAll(result);
      }
      if (result.length < size) {
        hasMoreData.value = false;
      }
    } catch (e) {
      print("더 불러오기 실패: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}