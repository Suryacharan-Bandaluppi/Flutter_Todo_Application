import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_application/theme/app_theme.dart';

class ToastUtil {
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: AppTheme.primaryGreen,
      textColor: AppTheme.textBlack,
      fontSize: 14,
    );
  }

  static void success2(BuildContext context, String message) {
    final fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      gravity: ToastGravity.TOP,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static void error(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: AppTheme.accentRed,
      textColor: AppTheme.textBlack,
      fontSize: 14,
    );
  }
}
