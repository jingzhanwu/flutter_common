import 'package:flutter_common/src/config/resource_manager.dart';

import './page_state.dart';
import 'package:flutter/material.dart';

///
/// 加载状态的view
///
class LoadingStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

///
/// 错误页面widget
///
class ErrorStateWidget extends StatelessWidget {
  final PageErrorState error;
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  const ErrorStateWidget({
    Key key,
    @required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage;
    var defaultTitle;
    var errorMessage = error.message;
    String defaultTextData = CStrings.retry;
    switch (error.errorType) {
      case PageErrorType.networkError:
        defaultImage = Transform.translate(
          offset: Offset(-50, 0),
          child: const Icon(IconFonts.pageNetworkError,
              size: 100, color: Colors.grey),
        );
        defaultTitle = CStrings.networkError;
        // errorMessage = ''; // 网络异常移除message提示
        break;
      case PageErrorType.defaultError:
        defaultImage =
            const Icon(IconFonts.pageError, size: 100, color: Colors.grey);
        defaultTitle = CStrings.loadMessageError;
        break;

      case PageErrorType.unAuthorizedError:
        return UnAuthStateWidget(
          image: image,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
    }

    return PageStateWidget(
      onPressed: this.onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

///
/// 空数据页面widget
///
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;

  const EmptyStateWidget(
      {Key key,
      this.image,
      this.message,
      this.buttonText,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageStateWidget(
      onPressed: this.onPressed,
      image: image ??
          const Icon(IconFonts.pageEmpty, size: 100, color: Colors.grey),
      title: message ?? CStrings.emptyDataMessage,
      buttonText: buttonText,
      buttonTextData: CStrings.retry,
    );
  }
}

///
/// 没有登陆或者未授权页面weidget
///
class UnAuthStateWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;

  const UnAuthStateWidget(
      {Key key,
      @required this.image,
      this.message,
      this.buttonText,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageStateWidget(
      onPressed: this.onPressed,
      image: image,
      title: message ?? CStrings.unAuthMessage,
      buttonText: buttonText,
      buttonTextData: CStrings.buttonLogin,
    );
  }
}

///
/// 未授权图片
/// 带hero动画的Image组件
///
class UnAuthStateImage extends StatelessWidget {
  final String url;
  UnAuthStateImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'loginLogo',
      child: Image.asset(
        url,
        width: 130,
        height: 100,
        fit: BoxFit.fitWidth,
        color: Theme.of(context).accentColor,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}

///
///页面状态通用view
///
class PageStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  PageStateWidget(
      {Key key,
      this.image,
      this.title,
      this.message,
      this.buttonText,
      @required this.onPressed,
      this.buttonTextData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle =
        Theme.of(context).textTheme.subhead.copyWith(color: Colors.grey);
    var messageStyle = titleStyle.copyWith(
        color: titleStyle.color.withOpacity(0.7), fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image ?? Icon(IconFonts.pageError, size: 80, color: Colors.grey[500]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? CStrings.loadMessageError,
                style: titleStyle,
              ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, minHeight: 150),
                child: SingleChildScrollView(
                  child: Text(message ?? '', style: messageStyle),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: PageStateButton(
            child: buttonText,
            textData: buttonTextData,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

///
/// 公用页面状态Button
///
class PageStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String textData;

  const PageStateButton({@required this.onPressed, this.child, this.textData})
      : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ??
          Text(
            textData ?? CStrings.retry,
            style: TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}
