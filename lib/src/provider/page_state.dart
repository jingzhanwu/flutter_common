///
/// 页面状态枚举类
///
enum PageState {
  idle, //正常状态
  loading, //加载中状态
  empty, //空页面状态
  error //出错状态
}

///
/// 错误类型
///
enum PageErrorType {
  defaultError, //一般错误
  networkError, //网络错误
  unAuthorizedError //认证错误
}

///
/// 页面错误状态
///
class PageErrorState {
  PageErrorType _errorType;
  String message;
  String errorMessage;

  PageErrorState(this._errorType, {this.message, this.errorMessage}) {
    _errorType ??= PageErrorType.defaultError;
    message ??= errorMessage;
  }

  PageErrorType get errorType => _errorType;

  ///定义对应的get 方法
  get isDefaultError => _errorType == PageErrorType.defaultError;

  get isNetworkError => _errorType == PageErrorType.networkError;

  get isAuthorizedError => _errorType == PageErrorType.unAuthorizedError;

  @override
  String toString() {
    return 'PageErrorState{errorType: $_errorType, message: $message, errorMessage: $errorMessage}';
  }
}
