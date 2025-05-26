import 'package:board_project/controllers/board_home_controller.dart';
import 'package:board_project/screens/board_view_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../widget/common_tab_button.dart';

class BoardHomeScreen extends StatefulWidget{
  const BoardHomeScreen({Key? key}) : super(key: key);

  @override
  _BoardHomeScreenState createState()=> _BoardHomeScreenState();
}

class _BoardHomeScreenState extends State<BoardHomeScreen>{
  final BoardHomeController controller = Get.put(BoardHomeController());
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
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
                    '게시판',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          /*미구현*/
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          /*미구현*/
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TabSelectorButton(label: '게시판', index: 0,   currentIndex: controller.currentTab.value,
                  onTap: () => controller.changeTab(0),),
                TabSelectorButton(label: '인기글(미구현)', index: 1,   currentIndex: controller.currentTab.value,
                  onTap: () => controller.changeTab(1),),
                TabSelectorButton(label: '내글(미구현)', index: 2,   currentIndex: controller.currentTab.value,
                  onTap: () => controller.changeTab(2),),
              ],
            )),

            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                switch (controller.currentTab.value) {
                  case 0:
                    return const BoardViewScreen();
                  case 1:
                    return const Text("인기글(미구현)");
                  case 2:
                    return const Text("내글(미구현)");
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}