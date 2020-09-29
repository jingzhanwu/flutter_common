import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// 带provider的widget，
/// 变化的view使用consumer包裹，局部刷新view
///
class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  ///数据变化时要更细的view
  final ValueWidgetBuilder<T> builder;
  final T model;
  final Widget child;
  final Function(T model) onModelReady;
  final bool autoDispose;

  ProviderWidget(
      {Key key,
      @required this.model,
      this.onModelReady,
      @required this.builder,
      this.child,
      this.autoDispose = true});

  @override
  State<StatefulWidget> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  //对应的provider 对象
  T model;

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
    //这里使用已经创建好的provider，所以使用value
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

///
/// 两个consumer的provider
///
class ProviderWidget2<P1 extends ChangeNotifier, P2 extends ChangeNotifier>
    extends StatefulWidget {
  final Function(BuildContext context, P1 model1, P2 model2, Widget child)
      builder;
  final P1 model1;
  final P2 model2;
  final Widget child;
  final Function(P1 model1, P2 model2) onModelReady;
  final bool autoDispose;

  ProviderWidget2(
      {Key key,
      @required this.builder,
      @required this.model1,
      @required this.model2,
      this.child,
      this.onModelReady,
      this.autoDispose = true});

  @override
  State<StatefulWidget> createState() => _ProviderWidgetState2<P1, P2>();
}

class _ProviderWidgetState2<P1 extends ChangeNotifier,
    P2 extends ChangeNotifier> extends State<ProviderWidget2<P1, P2>> {
  P1 model1;
  P2 model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.model1?.dispose();
      widget.model2?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<P1>.value(value: model1),
        ChangeNotifierProvider<P2>.value(value: model2)
      ],
      child: Consumer2<P1, P2>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
