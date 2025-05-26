import 'package:board_project/models/board.dart';
import 'package:get/get.dart';

import '../service/board_service.dart';

class BoardHomeController extends GetxController{
  final BoardService boardService = Get.find<BoardService>();
  RxInt currentTab = 0.obs;
  RxInt categoryTab = 0.obs;
  int page=0;
  int size=10;

  RxList<Board> boardList = <Board>[].obs;
  final List<String> buttonLabels = [
    "전체","공지","자유","Q&A","기타"
  ];

  @override
  Future<void> onInit() async{
    super.onInit();
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
      final category = buttonLabels[index];
      final result = await boardService.getBoardList(page, size);
      boardList.value = result;
    } catch (e) {
      print("에러 발생: $e");
    }
  }

}