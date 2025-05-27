import 'package:board_project/controllers/signin_controller.dart';
import 'package:board_project/models/member.dart';
import 'package:board_project/screens/home_screen.dart';
import 'package:board_project/storage/local_stroage.dart';
import 'package:board_project/widget/common_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../widget/common_button.dart';
import '../widget/common_snackbar.dart';
import '../widget/common_text_field.dart';

class SigninScreen extends StatefulWidget{
  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState()=> _SigninScreenState();
}
class _SigninScreenState extends State<SigninScreen>{
  final SigninController controller = Get.find<SigninController>();
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearLoginFields();
        return true;
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: "로그인",
          onBack: () {
            controller.clearLoginFields();
            Get.back();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() {
                final hasInput = controller.usernameController.text.isNotEmpty;
                final isValid = controller.isUsernameCheck.value;
                return ValidatableTextField(
                  label: "이메일",
                  hintText: "이메일을 입력해주세요",
                  controller: controller.usernameController,
                  isValid: !hasInput || isValid,
                  errorText: "이메일 형식이 옳바르지 않습니다.",
                  onChanged: (_) => controller.validateUsername(),
                );
              }),
              SizedBox(height: 16),
              Obx(() {
                final hasInput = controller.passwordController.text.isNotEmpty;
                final isValid = controller.isPasswordCheck.value;
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
              SizedBox(height: 24),
              CommonButton(
                onPressed: () async {
                  String check = controller.inputCheck();
                  if (check.isNotEmpty) {
                    showSnackBar(context, check);
                    return;
                  } else {
                    final member = Member(
                      username: controller.usernameController.text,
                      name: '',
                      password: controller.passwordController.text,
                      confirmPassword: '',
                    );
                    bool loginCheck = await controller.trySignin(member);
                    if (loginCheck) {
                      UserBox().setUsername(member.username);
                      controller.clearLoginFields();
                      Get.offAllNamed('/home');
                    } else {
                      showSnackBar(context, "아이디 또는 비밀번호가 틀립니다.");
                    }
                  }
                },
                label: "로그인",
              ),
            ],
          ),
        ),
      ),
    );
  }
}