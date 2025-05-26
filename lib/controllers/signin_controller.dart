import 'package:board_project/models/member.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../service/auth_service.dart';

class SigninController extends GetxController{

  final AuthService authService;
  SigninController(this.authService);
  final usernameController =  TextEditingController();
  final passwordController =  TextEditingController();
  String errorText = '';
  final isUsernameCheck = false.obs;
  final isPasswordCheck = false.obs;
  final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!%*#?&])[A-Za-z\d!%*#?&]{8,}$');
  final usernameRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');



  void validateUsername() {
    isUsernameCheck.value = usernameRegExp.hasMatch(usernameController.text.trim());
  }

  void validatePassword() {
    isPasswordCheck.value = passwordRegExp.hasMatch(passwordController.text.trim());
  }

  String inputCheck(){
    if(usernameController.text.trim().isEmpty){
      return "이메일을 입력해주세요";
    }
    if(isUsernameCheck.value == false){
      return "이메일 형식이 아닙니다.";
    }
    if(passwordController.text.trim().isEmpty){
      return "비밀번호를 입력해주세요";
    }
    if(isPasswordCheck.value == false){
      return "비밀번호 형식이 옳바르지 않습니다.";
    }
    return "";
  }

  Future<bool> trySignin(Member member) async{
    bool check = false;
     check  = await authService.signin(member);
     if(!check){
       errorText ="아이디 또는 비밀번호가 틀립니다";
       update();
     }
     return check;
  }

  void clearLoginFields() {
    usernameController.clear();
    passwordController.clear();
    isUsernameCheck.value = false;
    isPasswordCheck.value = false;
    errorText = "";
  }

  void disposeControllers() {
    usernameController.dispose();
    passwordController.dispose();
  }
  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }
}

