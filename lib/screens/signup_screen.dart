import 'package:board_project/controllers/signup_controller.dart';
import 'package:board_project/storage/local_stroage.dart';
import 'package:board_project/widget/common_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/member.dart';
import '../widget/common_snackbar.dart';
import '../widget/common_text_field.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState ()=>_SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen>{
  final SignupController controller = Get.find<SignupController>();
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearSignupFields();
        return true;
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: '회원가입',
          onBack: () {
            controller.clearSignupFields();
            Get.back();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Obx(() {
                        final hasInput = controller.usernameController.text.isNotEmpty;
                        final isValid = controller.isUsernameValidCheck.value;
                        return ValidatableTextField(
                          label: "이메일",
                          hintText: "이메일을 입력해주세요",
                          controller: controller.usernameController,
                          isValid: !hasInput || isValid,
                          errorText: "이메일 형식이 옳바르지 않습니다.",
                          onChanged: (_) => controller.validateUsername(),
                        );
                      }),
                      Obx(() => ValidatableTextField(
                        label: "이름",
                        hintText: "이름을 입력해주세요",
                        controller: controller.nameController,
                        isValid: controller.isNameCheck.value,
                      )),
                      Obx(() {
                        final hasInput = controller.passwordController.text.isNotEmpty;
                        final isValid = controller.isPasswordValidCheck.value;
                        return ValidatableTextField(
                          label: "비밀번호",
                          hintText: "비밀번호는 8자 이상, 숫자, 영문자, 특수문자(!%*#?&) 1개 이상의 조합",
                          controller: controller.passwordController,
                          isValid: !hasInput || isValid,
                          obscureText: true,
                          errorText: "비밀번호는 8자 이상, 숫자, 영문자, 특수문자(!%*#?&) 1개 이상의 조합",
                          onChanged: (_) => controller.validatePassword(),
                        );
                      }),
                      Obx(() => ValidatableTextField(
                        label: "비밀번호 확인",
                        hintText: "이전 비밀번호",
                        obscureText: true,
                        controller: controller.passwordConfirmController,
                        isValid: controller.isPasswordConfirmCheck.value,
                        errorText: "비밀번호가 일치하지 않습니다.",
                      )),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        String check = controller.inputCheck();
                        if (check.isNotEmpty) {
                          showSnackBar(context, check);
                          return;
                        } else {
                          final member = Member(
                            username: controller.usernameController.text,
                            name: controller.nameController.text,
                            password: controller.passwordController.text,
                            confirmPassword: controller.passwordConfirmController.text,
                          );
                          bool success = await controller.trySignup(member);
                          if (success) {
                            UserBox().setUsername(member.username);
                            UserBox().setName(member.name);
                            showSnackBar(context, "회원가입 성공");
                            Get.offAllNamed('/home');
                          } else {
                            showSnackBar(context, "회원가입 실패 잠시 후에 다시 가입해주세요.");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "회원가입 완료",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}