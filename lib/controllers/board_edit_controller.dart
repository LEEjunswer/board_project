import 'dart:io';

import 'package:board_project/controllers/board_home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/board.dart';
import '../service/board_service.dart';
class BoardEditController extends GetxController {
  Rxn<Board> board = Rxn<Board>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final isTitleValid = false.obs;
  final isContentValid = false.obs;
  RxList<String> categoryKoreanList=["공지","자유","Q&A","기타"].obs;
  RxList<String> categoryList=["NOTICE","FREE","QNA","ETC"].obs;
  final choiceCategory = 0.obs;
  final Rxn<File> selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();
  final selectedCategory = ''.obs;
  final BoardService boardService = Get.find<BoardService>();
  final isLoading = true.obs;
  final BoardHomeController boardHomeController = Get.find<BoardHomeController>();
  @override
  Future<void> onInit() async {
    super.onInit();

    if (Get.arguments != null && Get.arguments['board'] != null) {
      board.value = Get.arguments['board'];
    final imageUrl = board.value?.imageUrl;
      if (imageUrl != null && imageUrl.isNotEmpty) {
     selectedImage.value = File(imageUrl);
      }
      titleController.text = board.value?.title ?? '';
      contentController.text = board.value?.content ?? '';
      selectedCategory.value = board.value?.boardCategory ?? '';
      choiceCategory.value = categoryList.indexOf(selectedCategory.value);
      validateTitle();
      validateContent();
    }

    isLoading.value = false;
  }

  void categoryTabChange(int index) {
    choiceCategory.value = index;
    selectedCategory.value = categoryList[index];
  }

  void validateTitle() {
    final title = titleController.text.trim();
    isTitleValid.value = title.length >= 2;
  }

  void validateContent() {
    final content = contentController.text.trim();
    isContentValid.value = content.length >= 2;
  }

  String inputCheck() {
    if (titleController.text.trim().length < 2) {
      return '제목을 2자 이상 입력해주세요';
    }
      if (contentController.text.trim().length < 2) {
        return '내용을 2자 이상 입력해주세요';
      }if (selectedCategory.value.isEmpty) {
          return '카테고리를 선택해주세요';
        }
    return '';
  }

 /* Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }*/

  void clearBoardFields() {
    titleController.clear();
    contentController.clear();
    selectedImage.value = null;
    isTitleValid.value = false;
    isContentValid.value = false;
    selectedCategory.value = '';
    choiceCategory.value = 0;
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

  Future<bool> updateBoard(Board board) async {
    try {
      final result = await boardService.updateBoard(board, image: selectedImage.value);
      return result;
    } catch (e) {
      print('게시글 수정 실패: $e');
      return false;
    }
  }


  Future<void> updateBoardList() async {
     await boardHomeController.fetchDataForTab(boardHomeController.categoryTab.value);
  }
}