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
  flutter_common:
    git:
      url: https://github.com/jingzhanwu/flutter_common.git
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

### 页面中`ProviderWidget`的使用
ProviderWidget的泛型为Provider类型

```
class AdvertListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = Strings.of(context).advertListTitle;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ProviderWidget<AdvertModel>(
        model: AdvertModel(),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          if (model.isLoading) {
            return LoadingStateWidget();
          }
          if (model.isEmpty) {
            return EmptyStateWidget();
          }
          if (model.isError) {
            return ErrorStateWidget(
              error: model.pageErrorState,
              message: '数据解析出错了',
            );
          }
          return ListView.builder(
              itemCount: model.list.length,
              //类IOS 回弹效果，item不足一屏时，设置parent即可
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return _listItem(context, model.list[index]);
              });
        },
      ),
    );
  }

  Widget _listItem(BuildContext context, AdvertEntry ad) {
    return Ink(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          showToast("当前id=${ad.id}");
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("广告id：${ad.id}"),
                  Text(
                    "链接：${ad.adLink}",
                    style: TextStyle(
                        fontSize: 12.0, color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
            Divider(height: 0.7),
          ],
        ),
      ),
    );
  }
}

```