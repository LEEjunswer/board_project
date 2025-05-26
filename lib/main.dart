import 'package:board_project/controllers/signin_controller.dart';
import 'package:board_project/routes/app_routes.dart';
import 'package:board_project/screens/login_screen.dart';
import 'package:board_project/service/auth_service.dart';
import 'package:board_project/service/board_service.dart';
import 'package:board_project/storage/local_stroage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controllers/signup_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');
  final dWidth = await calcWidth();
  Get.put(AuthService());
  Get.put(SignupController(Get.find<AuthService>()));
  Get.put(SigninController(Get.find<AuthService>()));
  Get.put(BoardService(Get.find<AuthService>()));

  final userBox = UserBox();
  await userBox.init();
  runApp(
    ScreenUtilInit(
      designSize: Size(dWidth, 800),
      minTextAdapt: true,
      builder: (context, _) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              background: Colors.white,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
          home: const LoginScreen(),
          getPages: GetXRoutes.route,
        );
      },
    ),
  );
}

Future<double> calcWidth() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  double width = 360;

  if (GetPlatform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    final machineName = iosInfo.utsname.machine ?? '';
    print('##### Running on iOS: $machineName');

    if (machineName.toUpperCase().contains('IPAD')) {
      width = 600;
    }
  } else if (GetPlatform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('##### Running on Android: ${androidInfo.model}');
  }

  return width;
}