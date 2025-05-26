import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/board_edit_controller.dart';
import '../controllers/home_controller.dart';
import '../models/board.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_button.dart';
import '../widget/common_category_button.dart';
import '../widget/common_content_field.dart';
import '../widget/common_garotext_field.dart';
import '../widget/common_image_picker.dart';
import '../widget/common_modal.dart';
import '../widget/common_snackbar.dart';

class BoardEditScreen extends StatefulWidget{
  const BoardEditScreen({Key? key}) : super(key: key);

  @override
  _BoardEditScreenState createState() => _BoardEditScreenState();
}
class _BoardEditScreenState extends State<BoardEditScreen> {
  final BoardEditController controller = Get.put(BoardEditController());
  final BottomNavgationBarController homeController = Get.find<BottomNavgationBarController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: CommonAppBar(
          title: "게시글 수정",
          onBack: () => _onBackPressed(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final hasInput = controller.titleController.text.isNotEmpty;
                final isValid = controller.isTitleValid.value;
                return GaroValidatableTextField(
                  label: "제목 :",
                  hintText: "제목은 공백 제외 2글자 이상 입력",
                  controller: controller.titleController,
                  isValid: !hasInput || isValid,
                  errorText: "제목은 2글자 이상이어야 합니다.",
                  onChanged: (_) => controller.validateTitle(),
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "카테고리 :",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(controller.categoryKoreanList.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: CategoryButton(
                                label: controller.categoryKoreanList[index],
                                index: index,
                                currentIndex: controller.choiceCategory.value,
                                onTap: () => controller.categoryTabChange(index),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 25),
              BoardContentField(
                hintText: "내용을 입력해주세요",
                controller: controller.contentController,
                onChanged: (_) => controller.validateContent(),
              ),
              Obx(() {
                return CommonImagePicker(
                  imageFile: controller.selectedImage.value,
                  onPickImage: controller.pickImage,
                  onRemoveImage: controller.removeImage,
                );
              }),
              const SizedBox(height: 25),
              CommonButton(
                label: '수정 완료',
                onPressed: () async {
                  String check = controller.inputCheck();
                  if (check.isNotEmpty) {
                    showSnackBar(context, check);
                    return;
                  } else {
                    final updatedBoard = Board(
                      id: controller.board.value?.id,
                      title: controller.titleController.text,
                      content: controller.contentController.text,
                      category: controller.selectedCategory.value,
                    );
                    final result = await controller.updateBoard(updatedBoard);
                    if (!result) {
                      showSnackBar(context, "수정 실패. 다시 시도해주세요.");
                      return;
                    }
                    await controller.updateBoardList();
                    controller.clearBoardFields();
                    homeController.selectedIndex.value = 0;
                    Get.toNamed('/home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    await Get.dialog(
      modal(
        mainText: '게시글 수정을 취소하시겠습니까?',
        subText: '',
        button1Function: () {
          Get.back(); // dialog
          Get.back(); // screen
        },
        button2Function: () {
          Get.back();
        },
        button1Text: '예',
        button2Text: '취소',
      ),
    );
    return false;
  }
}