import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// 支持selector的 provider,
/// selector 控制粒度比consumer更细，可减少view的刷新，提高性能
///
class ProviderSelectorWidget<P extends ChangeNotifier, S>
    extends StatefulWidget {
  ///继承provider的数据model
  final P model;

  ///model改变时更新的builder，S为具体的变化value
  final ValueWidgetBuilder<S> builder;

  ///具体返回要改变的value
  final S Function(BuildContext, P) selector;

  ///model准备完成回调函数
  final Function(P model) onModelReady;

  ///填充的view
  final Widget child;
  final bool autoDispose;

  ProviderSelectorWidget(
      {Key key,
      @required this.model,
      this.child,
      @required this.builder,
      this.selector,
      this.onModelReady,
      this.autoDispose});

  @override
  State<StatefulWidget> createState() => _ProviderSelectorState<P, S>();
}

class _ProviderSelectorState<P extends ChangeNotifier, S>
    extends State<ProviderSelectorWidget<P, S>> {
  P model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.model?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<P>.value(
      value: model,
      child: Selector(
        builder: widget.builder,
        selector: widget.selector,
        child: widget.child,
      ),
    );
  }
}
