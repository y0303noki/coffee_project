import 'dart:typed_data';

import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/convert_widget_to_image_key.dart';
import 'package:coffee_project/ui/list_card.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart';

// import 'package:share/share.dart';

class AddOrEditCardPage extends StatelessWidget {
  AddOrEditCardPage(
    this.editCard,
  );
  final myController = TextEditingController();
  // 指定した日付
  DateTime postDate = DateTime.now();
  // 編集or追加
  ListCard editCard;
  bool isEdit;

  // 名前
  String _name = '';
  // メモ
  String memo = '';
  // 公開or非公開
  bool _isPublic = false;
  // スコア
  int _score = 3;
  // 画像
  String _imageUrl = null;
  File _imageFile = null;

  ListCard listCard;

  // Widgetをimageにするためのkey
  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    isEdit = editCard != null;
    if (isEdit) {
      print(editCard);
      _name = editCard.name;
      memo = editCard.memo;
      _isPublic = editCard.isPublic;
      _score = editCard.score;
      _imageUrl = editCard.imageUrl;
    }

    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('投稿'),
        ),
        body: ChangeNotifierProvider<CardModel>(
          create: (_) => CardModel(),
          child: Stack(
            children: [
              Consumer<CardModel>(builder: (context, model, child) {
                // 画像のファイルパスをセット
                _imageFile = model.imageFile;
                listCard = ListCard(_name, postDate, memo, _isPublic, _score,
                    'A', _imageFile, null, true);
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            child: listCard,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: TextEditingController(text: _name),
                                decoration: InputDecoration(
                                  labelText: '名前',
                                  hintText: '何飲んだ？',
                                ),
                                onChanged: (text) {
                                  // TODO: ここで取得したtextを使う
                                  _name = text;
                                  model.refresh();
                                },
                              ),
                              TextField(
                                controller: TextEditingController(text: memo),
                                decoration: InputDecoration(
                                  labelText: 'ひとこと',
                                  hintText: 'メモ？',
                                ),
                                onChanged: (text) {
                                  // TODO: ここで取得したtextを使う
                                  memo = text;
                                  model.refresh();
                                },
                              ),
                              // スコア
                              Text('スコア'),
                              RatingBar.builder(
                                initialRating: _score.toDouble(),
                                minRating: 1,
                                itemSize: 30,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  _score = rating.toInt();
                                  model.refresh();
                                },
                              ),
                              // 公開設定、まだ使わない
                              // SwitchListTile(
                              //   value: _isPublic,
                              //   activeColor: Colors.orange,
                              //   activeTrackColor: Colors.red,
                              //   inactiveThumbColor: Colors.blue,
                              //   inactiveTrackColor: Colors.grey,
                              //   secondary: Icon(
                              //     Icons.public,
                              //     color:
                              //         _isPublic ? Colors.orange[700] : Colors.grey[500],
                              //     size: 30.0,
                              //   ),
                              //   title: Text('公開する'),
                              //   onChanged: (bool e) {
                              //     _isPublic = e;
                              //     model.refresh();
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        TextButton(
                          child: Text('画像変更'),
                          onPressed: () {
                            model.showImagePicker();
                            _imageFile = model.imageFile;
                            model.refresh();
                          },
                        ),
                        TextButton(
                          child: Text('テスト用'),
                          onPressed: () {
                            _showSuccsessDialog(context);
                          },
                        ),
                        TextButton(
                          child: Text('投稿する'),
                          onPressed: () async {
                            // ローディング開始
                            model.startLoading();

                            _name = _name == '' ? 'nullでした' : _name;
                            DateTime now = DateTime.now();
                            CoffeeCard addCard = new CoffeeCard(
                                name: _name,
                                score: _score,
                                memo: memo,
                                isPublic: _isPublic,
                                imageUrl: _imageUrl,
                                updatedAt: now,
                                createdAt: now);
                            final String addCardResult =
                                await model.addCard(addCard);
                            print(addCardResult);
                            // ローディング終了
                            model.endLoading();

                            final SnackBar snackBar = SnackBar(
                              content: Text('投稿が完了しました！'),
                            );

                            // 画面戻る
                            Navigator.of(context).pop(snackBar);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Consumer<CardModel>(
                builder: (context, model, child) {
                  return model.isLoading
                      ? Container(
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 投稿成功ダイアログ
  Future _showSuccsessDialog(BuildContext context) async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('Nice Coffee!'),
        content: new Text('登録成功しました。SNSでシェアしますか？'),
        actions: <Widget>[
          new SimpleDialogOption(
            child: new Text('Yes'),
            onPressed: () {
              Navigator.pop(context, 'Yes');
            },
          ),
          new SimpleDialogOption(
            child: new Text('NO'),
            onPressed: () {
              Navigator.pop(context, 'No');
            },
          ),
        ],
      ),
    );
    switch (value) {
      case 'Yes':
        print('YES!!!');
        final bytes = await exportToImage(_globalKey);
        final nowUnixTime = DateTime.now().millisecondsSinceEpoch;

        await Share.file('coffee Image', 'CoffeeProject$nowUnixTime',
            bytes.buffer.asUint8List(), 'image/png',
            text: '今日の1杯を投稿しました！ #CoffeeProject');

        break;
      case 'No':
        print('No!!!');
        break;
    }
  }

  // Widgetをimageに変換してByteDataを返す
  Future<ByteData> exportToImage(GlobalKey globalKey) async {
    final boundary =
        globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 3,
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData;
  }
}
