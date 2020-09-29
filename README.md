# flutter_common

flutter项目的基础库.

## 功能

- provider的封装
- provider结合widget使用的封装
- 空页面，错误页面处理
- Dio的封装
- 常用基础plugin的引入，如pull_to_refresh,sp，toast，url_launcher等等

## 使用

下载项目到本地，然后
pubspec.yaml文件中引入,如我放在和项目同级的目录

```
dependencies:
  common:
    path: ../common
```

### dio 初始化
```
initDio(baseUrl: "http://baidu.com");
```

### StorageManager初始化
```
/// 初始化本地存储
await StorageManager.init();

```

### MaterialApp配置
包括OKToast、Provider、Refresh等配置，其中OKToast和Refresh是必须的，否则页面中使用toast与列表刷新时会出错，provider根据自己业务需求配置。

```
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>(
            create: (context) => ThemeModel(),
          )
        ],
        child: Consumer<ThemeModel>(
          builder: (context, model, child) {
            return RefreshConfiguration(
              hideFooterWhenNotFull: false,
              child: MaterialApp(
                debugShowCheckedModeBanner: true,
                locale: Locale('zh'),
                theme: model.themeData(),
                localizationsDelegates: [
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  StringsLocalizationsDelegate.delegate,
                ],
                supportedLocales:
                    StringsLocalizationsDelegate.delegate.supportedLocales,
                home: HomePage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
```