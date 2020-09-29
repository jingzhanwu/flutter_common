import 'package:flutter_common/src/net/http_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //dio初始化
  test('init dio', () {
    initDio(baseUrl: "http://baidu.com");
  });
}
