import 'package:board_project/screens/board_home_screen.dart';
import 'package:board_project/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/home_controller.dart';
import '../widget/common_modal.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final HomeController homeController = Get.put(HomeController(), permanent: true);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    final bottom = Get.put(BottomNavgationBarController(), permanent: true);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:

        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        print("paused");
        break;
      case AppLifecycleState.detached:

        print("detached");
        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final BottomNavgationBarController controller =
    Get.find<BottomNavgationBarController>();

    List<Widget> tabPages = <Widget>[
      const BoardHomeScreen(),
      const ProfileScreen()
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        _onBackKey();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,

        body: Obx(
                () => SafeArea(child: tabPages[controller.selectedIndex.value])),
        bottomNavigationBar: const BottomNavgationBar(),
      ),
    );
  }
}

Future<bool> _onBackKey() async {
  return await Get.dialog(modal(
    mainText: '보드 앱을 종료 하시겠습니까?',
    subText: '',
    button1Function: () {
      SystemNavigator.pop();
    },
    button2Function: () {
      Get.back();
    },
    button1Text: '종료',
    button2Text: '취소',
  ));
}
