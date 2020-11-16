import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import './http_base.dart';

///初始化dio的实例
final Dio http = Dio();

///
/// 初始化dio配置
/// [baseUrl] http的请求baseUrl
/// [header]  http 头
///
initDio(
    {@required String baseUrl,
    Map<String, String> header,
    List<Interceptor> interceptors}) {
  ///自定义头设置
  if (header != null && header.length > 0) {
    setHeader(header);
  }

  ///baseUrl设置
  http.options.baseUrl = baseUrl;

  ///设置默认的拦截器
  http.interceptors.add(HeaderInterceptor());

  ///自定义拦截器设置
  if (interceptors != null && interceptors.length > 0) {
    http.interceptors.addAll(interceptors);
  }

  ///最后添加日志拦截器
  http.interceptors.add(LogInterceptor(
      request: true, requestHeader: true, responseBody: true)); //开启请求日志;
}

///
/// 设置http请求头
///
setHeader(Map<String, String> header) {
  header.forEach((key, value) {
    http.options.headers[key] = value;
  });
}
