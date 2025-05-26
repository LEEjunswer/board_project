import 'package:board_project/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';

import '../models/member.dart';
import '../service/auth_service.dart';


class SignupController extends GetxController {
  final AuthService authService;

  SignupController(this.authService);

  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  final isUsernameValidCheck = false.obs;
  final isPasswordValidCheck = false.obs;
  final isPasswordConfirmCheck= false.obs;
  final isNameCheck = true.obs;


  final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!%*#?&])[A-Za-z\d!%*#?&]{8,}$');
  final usernameRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');


  void validateUsername() {
    isUsernameValidCheck.value = usernameRegExp.hasMatch(usernameController.text.trim());
  }

  void validatePassword() {
    isPasswordValidCheck.value = passwordRegExp.hasMatch(passwordController.text.trim());
  }

  String inputCheck(){
    if(usernameController.text.trim().isEmpty){
      return "이메일을 입력해주세요";
    }
    if(isUsernameValidCheck.value == false){
      return "이메일 형식이 아닙니다.";
    }
    if(nameController.text.trim().isEmpty){
      return "이름을 입력해주세요";
    }
    if(passwordController.text.trim().isEmpty){
     return "비밀번호를 입력해주세요";
    }
    if(isPasswordValidCheck.value == false){
      return "비밀번호 형식이 옳바르지 않습니다.";
    }
    if(passwordConfirmController.text.trim().isEmpty){
      return "비밀번호 확인을 입력해주세요";
    }
    if(passwordConfirmController.text.trim().isEmpty != passwordController.text.trim().isEmpty){
      return "비밀번호와 비밀번호 확인이 다릅니다.";
    }
    return "";
  }


  void disposeControllers() {
    usernameController.dispose();
    nameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
  }

  Future<bool> trySignup(Member member) async {
    bool success = await authService.signup(member);
    if (success) {
      print("회원가입 성공");
      return success;
    } else {
      print("회원가입 실패");
      return success;
    }
  }

  void clearSignupFields() {
    usernameController.clear();
    nameController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
    isUsernameValidCheck.value = false;
    isPasswordValidCheck.value = false;
    isPasswordConfirmCheck.value = false;
    isNameCheck.value = true;
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }
}
