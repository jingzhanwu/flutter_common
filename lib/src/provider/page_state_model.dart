import 'dart:io';

import 'package:flutter_common/src/config/resource_manager.dart';
import 'package:flutter_common/src/net/http_base.dart';

import './page_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';


///
/// 具有页面状态处理的provider 基类
/// 具体的provider可继承它处理具体业务
///
class PageStateModel with ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  /// 当前的页面状态,默认为loading,可在viewModel的构造方法中指定;
  PageState _pageState;

  /// 根据状态构造
  ///
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.loading);
  PageStateModel({PageState viewState})
      : _pageState = viewState ?? PageState.idle {
    debugPrint('PageStateModel---constructor--->$runtimeType');
  }

  /// PageState
  PageState get pageState => _pageState;

  set pageState(PageState pageState) {
    _pageErrorState = null;
    _pageState = pageState;
    notifyListeners();
  }

  /// PageErrorState
  PageErrorState _pageErrorState;

  PageErrorState get pageErrorState => _pageErrorState;

  ///
  /// get
  ///
  bool get isLoading => pageState == PageState.loading;

  bool get isIdle => pageState == PageState.idle;

  bool get isEmpty => pageState == PageState.empty;

  bool get isError => pageState == PageState.error;

  /// set
  void setIdle() {
    pageState = PageState.idle;
  }

  void setLoading() {
    pageState = PageState.loading;
  }

  void setEmpty() {
    pageState = PageState.empty;
  }

  /// [e]分类Error和Exception两种
  void setError(e, stackTrace, {String message}) {
    PageErrorType errorType = PageErrorType.defaultError;

    /// 见https://github.com/flutterchina/dio/blob/master/README-ZH.md#dioerrortype
    if (e is DioError) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        // timeout
        errorType = PageErrorType.networkError;
        message = e.error;
      } else if (e.type == DioErrorType.RESPONSE) {
        // incorrect status, such as 404, 503...
        message = e.error;
      } else if (e.type == DioErrorType.CANCEL) {
        // to be continue...
        message = e.error;
      } else {
        // dio将原error重新套了一层
        e = e.error;
        if (e is UnAuthorizedException) {
          stackTrace = null;
          errorType = PageErrorType.unAuthorizedError;
        } else if (e is NotSuccessException) {
          stackTrace = null;
          message = e.message;
        } else if (e is SocketException) {
          errorType = PageErrorType.networkError;
          message = e.message;
        } else {
          message = e.message;
        }
      }
    }
    pageState = PageState.error;

    _pageErrorState = PageErrorState(
      errorType,
      message: message,
      errorMessage: e.toString(),
    );

    printErrorStack(e, stackTrace);
    onError(pageErrorState);
  }

  ///
  /// 错误处理函数，子类复写
  ///
  void onError(PageErrorState pageStateError) {}

  /// 显示错误消息
  showErrorMessage(context, {String message}) {
    if (pageErrorState != null || message != null) {
      if (pageErrorState.isNetworkError) {
        message ??= CStrings.networkError;
      } else {
        message ??= pageErrorState.message;
      }
      Future.microtask(() {
        showToast(message, context: context);
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_pageState: $pageState, _pageErrorState: $_pageErrorState}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    debugPrint('view_state_model dispose -->$runtimeType');
    super.dispose();
  }
}

/// [e]为错误类型 :可能为 Error , Exception ,String
/// [s]为堆栈信息
printErrorStack(e, s) {
  debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
  if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
}
