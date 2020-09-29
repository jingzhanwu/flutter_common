import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// 存储管理
/// 包括sp存储，文件存储，本地json文件村粗
///
class StorageManager {
  /// app全局配置 eg:theme
  static SharedPreferences sharedPreferences;

  /// 临时目录 eg: cookie
  static Directory temporaryDirectory;

  /// 初始化必备操作 eg:user数据
  static LocalStorage localStorage;

  /// 必备数据的初始化操作
  ///
  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    temporaryDirectory = await getTemporaryDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
    localStorage = LocalStorage('LocalStorage.json');
    await localStorage.ready;
  }
}
