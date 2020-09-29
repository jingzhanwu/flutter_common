
import './page_state_model.dart';

///
/// 数据为list的provider
///
abstract class PageStateListModel<T> extends PageStateModel {
  List<T> list = [];

  ///第一次进入页面时，初始化数据
  initData() async {
    setLoading();
    await refresh(init: true);
  }

  Future<List<T>> refresh({bool init = false}) async {
    try {
      List<T> data = await loadData();
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        setIdle();
      }
      return data;
    } catch (e, s) {
      if (init) list.clear();
      setError(e, s);
      return null;
    }
  }

  ///
  /// 加载数据，子类去实现
  ///
  Future<List<T>> loadData();

  ///
  /// 数据加载完成时回调处理
  ///
  onCompleted(List<T> data) {}
}
