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
initDio({@required String baseUrl, Map<String, String> header}) {
  /// 初始化 加入app通用处理
  (http.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  http.interceptors..add(HeaderInterceptor());
  http.interceptors.add(ApiInterceptor());
  http.options.baseUrl = baseUrl;
  if (header != null && header.length > 0) {
    setHeader(header);
  }
}

///
/// 设置http请求头
///
setHeader(Map<String, String> header) {
  header.forEach((key, value) {
    http.options.headers[key] = value;
  });
}

///
/// http请求响应拦截器处理
///
class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    debugPrint('--request-->url--> ${options.baseUrl}${options.path}' +
        '\nqueryParameters: ${options.queryParameters}' +
        '\ndata: ${options.data}');
    return options;
  }

  @override
  onResponse(Response response) {
    debugPrint('--response-->${response.data}');
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      return http.resolve(response);
    } else {
      if (respData.code == -1001) {
        // 如果cookie过期,需要清除本地存储的登录信息
        // StorageManager.localStorage.deleteItem(UserModel.keyUser);
        throw const UnAuthorizedException(); // 需要登录
      } else {
        throw NotSuccessException.fromRespData(respData);
      }
    }
  }
}

///
/// http请求响应结果
///
class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}
