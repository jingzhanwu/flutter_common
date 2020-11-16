// 必须是顶层函数
import 'dart:io';
import 'package:dio/dio.dart';

/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    options.connectTimeout = 1000 * 45;
    options.receiveTimeout = 1000 * 45;
    options.headers['platform'] = Platform.operatingSystem;
    return options;
  }
}

///
/// 账号未认证或过期时的异常
///
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}

///
/// 接口响应的data没有成功时异常
///
class NotSuccessException implements Exception {
  String message;
  int code;

  NotSuccessException.fromRespData({this.code, this.message});

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}
