import 'package:board_project/controllers/board_create_controller.dart';
import 'package:board_project/controllers/home_controller.dart';
import 'package:board_project/storage/local_stroage.dart';
import 'package:board_project/widget/common_app_bar.dart';
import 'package:board_project/widget/common_category_button.dart';
import 'package:board_project/widget/common_content_field.dart';
import 'package:board_project/widget/common_garotext_field.dart';
import 'package:board_project/widget/common_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/board.dart';
import '../widget/common_button.dart';
import '../widget/common_image_picker.dart';
import '../widget/common_modal.dart';

class BoardCreateScreen extends StatefulWidget{
  const BoardCreateScreen({Key? key}) : super(key:  key);

  @override
  _BoardCreateScreenState createState()=> _BoardCreateScreenState();
}

class _BoardCreateScreenState extends State<BoardCreateScreen>{
  final BoardCreateController controller = Get.put(BoardCreateController());
  final BottomNavgationBarController homeController = Get.find<BottomNavgationBarController>();
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
        appBar: CommonAppBar(
        title: "게시글 작성",
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
            SizedBox(height: 10),
            SizedBox(height: 10),
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
                        children: List.generate(controller.categoryList.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: CategoryButton(
                              label: controller.categoryList[index],
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
            SizedBox(height: 25),
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
            SizedBox(height: 25),
            CommonButton(
              label: '등록',
              onPressed: () async {
                String check = controller.inputCheck();
                if (check.isNotEmpty) {
                  showSnackBar(context, check);
                  return;
                } else {
                  final board = Board(
                    title: controller.titleController.text,
                    content: controller.contentController.text,
                    category: controller.selectedCategory.value,
                  );
                  int submit = await controller.createBoard(board);
                  if (submit == 0) {
                    showSnackBar(context, "등록 실패 잠시 후에 다시 등록");
                    return;
                    }
                  await controller.updateBoardList();
                  controller.clearBoardFields();
                  homeController.selectedIndex(0);
                  Get.toNamed('/home');
                   }
                },
            ),
          ],
        ),
      ),
    ))
    ;

  }
}
Future<bool> _onBackPressed() async {
  await Get.dialog(modal(
      mainText: '게시글 작성을 취소하시겠습니까?',
      subText: '',
      button1Function: () {
        Get.back(); 
        Get.back(); 
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