import 'dart:io';

import 'package:board_project/controllers/board_home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../models/board.dart';
import '../service/board_service.dart';

class BoardCreateController extends GetxController{
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  RxList<String> categoryList=["공지","자유","Q&A","기타"].obs;
  RxInt choiceCategory = 0.obs;
  String errorText = '';
  final RxBool isTitleValid = false.obs;
  final RxBool isContentValid = false.obs;
  final Rxn<File> selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();
  final RxString selectedCategory = 'NOTICE'.obs;
  final BoardService boardService = Get.find<BoardService>();
  final BoardHomeController boardHomeController = Get.find<BoardHomeController>();
  @override
  Future<void> onInit() async{
    super.onInit();
  }


  void validateTitle() {
    final trimmed = titleController.text.replaceAll(' ', '');
    isTitleValid.value = trimmed.length >= 2;
  }
  void validateContent() {
    final trimmed = contentController.text.replaceAll(' ', '');
    isContentValid.value = trimmed.length >= 2;
  }

  void categoryTabChange(int index) {
    choiceCategory.value = index;

    switch (index) {
      case 0:
        selectedCategory.value = 'NOTICE';
        break;
      case 1:
        selectedCategory.value = 'FREE';
        break;
      case 2:
        selectedCategory.value = 'QNA';
        break;
      case 3:
        selectedCategory.value = 'ETC';
        break;
      default:
        selectedCategory.value = 'ETC';
    }
  }


  String inputCheck(){
    if(titleController.text.trim().length < 2){
      errorText ="제목을 2글자 이상 입력해주세요.";
      return errorText;
    }if(contentController.text.trim().length < 2) {
      errorText = "내용을 두글자 이상 입력해주세요.";
      return errorText;
    }
    errorText = '';
    return errorText;
  }


  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  Future<int> createBoard(Board board) async{
    int check = await boardService.createBoard(board ,image: selectedImage.value);
    return check;
  }

  void clearBoardFields() {
    titleController.clear();
    contentController.clear();
    selectedImage.value=null;
    isContentValid.value=false;
    isTitleValid.value=false;
    selectedCategory.value = 'NOTICE';
    choiceCategory.value=0;
  }

  Future<void> updateBoardList() async{
    boardHomeController.fetchDataForTab(boardHomeController.categoryTab.value);
  }
}