import 'package:coffee_project/model/shop_brand_dto.dart';
import 'package:coffee_project/view_model/shop_brand_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugPage extends StatelessWidget {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          '開発者モード',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: _buildSocialLogin(context),
    );
  }

  Widget _buildSocialLogin(BuildContext context) {
    String _shopBrandName = '';
    return ChangeNotifierProvider<ShopBrandModel>(
      create: (_) => ShopBrandModel(),
      child: Consumer<ShopBrandModel>(
        builder: (context, model, child) {
          return Container(
              child: Column(
            children: [
              Text('shopBrandsにデータを追加する'),
              Text(
                "${model.shopBrandName}",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500),
              ),
              TextField(
                enabled: true,
                // 入力数
                // maxLength: 10,
                style: TextStyle(color: Colors.red),
                obscureText: false,
                maxLines: 1,
                // 名前
                onChanged: (text) {
                  model.shopBrandName = text;
                  model.refresh();
                },
              ),
              TextButton(
                child: Text('投稿する'),
                onPressed: () async {
                  // ローディング開始
                  model.startLoading();

                  _shopBrandName = model.shopBrandName == ''
                      ? 'nullでした'
                      : model.shopBrandName;
                  DateTime now = DateTime.now();
                  ShopBrandDto addShopBrand = new ShopBrandDto(
                      id: 'testId',
                      isCommon: true,
                      name: _shopBrandName,
                      updatedAt: now,
                      createdAt: now);
                  final String result = await model.addShopBrand(addShopBrand);
                  // ローディング終了
                  model.endLoading();

                  if (result == 'ok') {
                  } else {
                    print('データ追加エラー！！');
                  }
                  final SnackBar snackBar = SnackBar(
                    content: Text('データ追加完了'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              TextButton(
                child: Text('取得する'),
                onPressed: () async {
                  // ローディング開始
                  model.startLoading();

                  DateTime now = DateTime.now();
                  final result = await model.findShopBrand();
                  // ローディング終了
                  model.endLoading();

                  final SnackBar snackBar = SnackBar(
                    content: Text('データ取得完了'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ],
          ));
        },
      ),
    );
  }
}
