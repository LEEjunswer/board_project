import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/*자주 사용하는 스낵바*/
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black87,
    ),
  );
}