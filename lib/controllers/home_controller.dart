import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeController extends GetxController {
  RxBool isEditClicked = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }
}


class BottomNavgationBarController extends GetxController {

  RxInt selectedIndex = 0.obs;


  static BottomNavgationBarController get to => Get.find();

  void changeIndex(int index) {
    selectedIndex.value = index;
    if (index == 0) {

    }

    if (index == 1) {
    }

  }

  void onLogout() {
    selectedIndex.value = 0;
  }
}

class BottomNavgationBar extends GetView<BottomNavgationBarController> {
  const BottomNavgationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      currentIndex: controller.selectedIndex.value,
      onTap: controller.changeIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color(0xFF8291AF),
      selectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: [

        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/board.png',
            width: 30.w,
            height: 30.w,
            fit: BoxFit.contain,
          ),
          label: "게시글",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/profile.png',
            width: 30.w,
            height: 30.w,
            fit: BoxFit.contain,

          ),
          label: "내 프로필",
        ),
      ],
    ));
  }
}