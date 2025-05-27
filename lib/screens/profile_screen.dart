import 'package:board_project/storage/local_stroage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../widget/common_modal.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}
class _ProfileScreenState extends State<ProfileScreen>{
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '나의 프로필',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _onBackPressed();
                        },
                        child: Text('로그아웃'),
                      ),
                    ],
                  ),
                ],
              ),

            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('접속중인 이메일 :'),
                      Text('${UserBox().getUsername()}'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원 이름 :'),
                      Text('${UserBox().getName()}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed() async {
  await Get.dialog(
    modal(
      mainText: '정말로 로그아웃하시겠습니까?',
      subText: '',
      button1Function: () {
        UserBox().clearTokens();
        Get.offAllNamed('/login');
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
