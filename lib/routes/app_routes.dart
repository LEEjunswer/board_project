import 'package:board_project/screens/board_create_screen.dart';
import 'package:board_project/screens/board_detail_screen.dart';
import 'package:board_project/screens/board_home_screen.dart';
import 'package:board_project/screens/board_edit_screen.dart';
import 'package:board_project/screens/board_view_screen.dart';
import 'package:board_project/screens/home_screen.dart';
import 'package:board_project/screens/login_screen.dart';
import 'package:board_project/screens/profile_screen.dart';
import 'package:board_project/screens/signin_screen.dart';
import 'package:board_project/screens/signup_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class GetXRoutes{
 static final route= [

  /*처음 앱 페이지*/
  GetPage(name: "/login", page: ()=> const LoginScreen()),

  /*회원가입 페이지*/
  GetPage(name: "/sign_up", page: () => const SignupScreen()),

  /*로그인 페이지*/
  GetPage(name: "/sign_in", page: () => const SigninScreen()),

  /*로그인 후 메인 화면 페이지*/
  GetPage(name: "/home", page: () => const HomeScreen()),

  GetPage(name:"/profile",page: () => const ProfileScreen()),

  /*게시글 홈 페이지*/
  GetPage(name: '/board_home', page:()=> const BoardHomeScreen()),

  /*보드 홈에 뷰 페이지*/
  GetPage(name: '/board_view', page: ()=> const BoardViewScreen()),

  /*게시글 작성 페이지*/
  GetPage(name: '/board_create', page: ()=> const BoardCreateScreen()),

  /*게시글 디테일 페이지*/
  GetPage(name: '/board_detail', page: ()=> const BoardDetailScreen()),

  /*게시글 수정 페이지*/
  GetPage(name: '/board_edit', page: () => const BoardEditScreen())
 ];
}