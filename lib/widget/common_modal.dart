
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Widget modal({
  required String mainText,
  String subText = '',
  int numberOfButton = 2,
  String button1Text = '종료',
  String button2Text = '아니요',
  String button1RoutePath = '',
  String button2RoutePath = '',
  void Function()? button1Function,
  void Function()? button2Function,
  Widget? extraWidget,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    backgroundColor: Colors.white,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 334, maxHeight: 180),

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              mainText,
              style: const TextStyle(
                color: Color(0xFF343434),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            if (extraWidget != null) extraWidget,

            if (subText.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            SizedBox(height: 16),

            IntrinsicHeight(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(

                    child: _buildDialogButton(
                      text: button2Text,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      onTap: button2Function,
                      borderColor: Color(0xFFDDE2EF),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildDialogButton(
                      text: button1Text,
                      textColor: Colors.white,
                      backgroundColor: Colors.black,
                      onTap: button1Function,
                      borderColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildDialogButton({
  required String text,
  required Color textColor,
  required Color backgroundColor,
  required Color borderColor,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap ?? () => Get.back(),
    child: Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}