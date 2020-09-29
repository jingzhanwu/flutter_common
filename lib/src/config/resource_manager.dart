import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageHelper {
  static String wrapAssets(String url) {
    return "assets/images/" + url;
  }

  static Widget placeHolder({double width, double height}) {
    return SizedBox(
        width: width,
        height: height,
        child: CupertinoActivityIndicator(radius: min(10.0, width / 3)));
  }

  static Widget error({double width, double height, double size}) {
    return SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.error_outline,
          size: size,
        ));
  }
}

class IconFonts {
  IconFonts._();

  static const IconData pageEmpty = IconData(0xe63c);
  static const IconData pageError = IconData(0xe600);
  static const IconData pageNetworkError = IconData(0xe678);
  static const IconData pageUnAuth = IconData(0xe65f);
}

class CStrings {
  CStrings._();

  static const String retry = "重试";
  static const String networkError = "网络连接异常,请检查网络或稍后重试";
  static const String loadMessageError = "加载失败";
  static const String emptyDataMessage = "暂无数据";
  static const String unAuthMessage = "未登录";
  static const String buttonLogin = "登陆";
}
