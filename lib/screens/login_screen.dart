import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';

import '../widget/common_button.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState()=> _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonButton(
              label: '회원가입',
              onPressed: () {
                Get.toNamed('/sign_up');
              },
              isOutlined: true,
            ),
            CommonButton(
              label: '로그인',
              onPressed: () {
                Get.toNamed('sign_in');
              },
            ),
          ],
        ),
      ),
    );
  }
}