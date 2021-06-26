import 'dart:typed_data';

import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/ui/album_page.dart';
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
import 'package:flutter_typeahead/flutter_typeahead.dart';

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

  // id
  String _id;
  // 名前
  String _name = '';
  // メモ
  String _memo = '';
  // 公開or非公開
  bool _isPublic = false;
  // お気に入り
  bool _isMyBottle = false;
  // スコア
  int _score = 3;
  // 画像
  String _imageUrl = null;
  File _imageFile = null;
  String _userImageId = null;

  // ボタンの活性/非活性
  bool _isAddButtonDisabled = false;

  ListCard listCard;

  // Widgetをimageにするためのkey
  GlobalKey _globalKey = GlobalKey();

  List<String> _suggestTitleList = [];

  @override
  Widget build(BuildContext context) {
    isEdit = editCard != null;
    if (isEdit) {
      _id = editCard.id;
      _name = editCard.name;
      _memo = editCard.memo;
      _isPublic = editCard.isPublic;
      _score = editCard.score;
      _userImageId = editCard.userImageId;
      _isMyBottle = editCard.isMyBottle;
      // _imageUrl = editCard.imageUrl;
    }

    // 名前
    TextEditingController _nameTextEditController =
        TextEditingController(text: _name);

    // メモ
    TextEditingController _memoTextEditingController =
        TextEditingController(text: _memo);

    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          title: Text(
            '投稿',
            style: Theme.of(context).textTheme.headline6,
          ),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: ChangeNotifierProvider<CardModel>(
          create: (_) => CardModel()..findThisMonthMyCoffee(),
          child: GestureDetector(
            // 水平方向にスワイプしたら画面を戻す
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 18 || details.delta.dx < -18) {
                Navigator.pop(context);
              }
            },
            // 垂直方向にスワイプしたら画面を戻す
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 25 || details.delta.dy < -25) {
                Navigator.pop(context);
              }
            },
            child: Stack(
              children: [
                Consumer<CardModel>(
                  builder: (context, model, child) {
                    // サジェストするための名前リストを取得
                    List<Coffee> thisMonthCount = model.thisMonthCoffee;
                    if (thisMonthCount.isNotEmpty) {
                      _suggestTitleList =
                          thisMonthCount.map((e) => e.name).toList();
                    }

                    if (_name == null ||
                        _name.isEmpty ||
                        _name.length <= 0 ||
                        _name.length >= 20) {
                      _isAddButtonDisabled = true;
                    } else {
                      _isAddButtonDisabled = false;
                    }

                    // 画像のファイルパスをセット
                    _imageFile = model.imageFile;
                    listCard = ListCard(
                        _id,
                        _name,
                        postDate,
                        _memo,
                        _isPublic,
                        _score,
                        _imageFile,
                        _userImageId,
                        true,
                        model,
                        _isMyBottle);
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
                                  // TextField(
                                  //   controller: _nameTextEditController,
                                  //   decoration: InputDecoration(
                                  //     labelStyle:
                                  //         TextStyle(color: Colors.black),
                                  //     labelText: '名前',
                                  //     hintText: '何飲んだ？',
                                  //   ),
                                  //   onChanged: (text) {
                                  //     if (text != null && text.length > 20) {
                                  //       print('20文字超えたらもう無理!');
                                  //     } else {
                                  //       _name = text;
                                  //       model.refresh();
                                  //     }
                                  //   },
                                  // ),
                                  // サジェスト
                                  TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      // autofocus: true,
                                      controller: _nameTextEditController,
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                      decoration: InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        labelText: '名前',
                                        hintText: '何飲んだ？',
                                      ),
                                      onChanged: (text) {
                                        if (text != null && text.length > 20) {
                                          print('20文字超えたらもう無理!');
                                        } else {
                                          _name = text;
                                          model.refresh();
                                        }
                                      },
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      if (pattern.isEmpty) {
                                        return [];
                                      }
                                      // pattern:入力された文字
                                      // return: サジェスト候補となる文字列を返す
                                      List<String> _filter = _suggestTitleList
                                          .where((element) => (element
                                                  .toLowerCase())
                                              .contains(pattern.toLowerCase()))
                                          .take(5)
                                          .toList();
                                      return _filter;
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    // サジェストの結果が0件の時のメッセージ
                                    noItemsFoundBuilder: (context) {
                                      return null;
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      _name = suggestion;
                                      _nameTextEditController.text = suggestion;
                                      model.refresh();
                                    },
                                  ),
                                  TextField(
                                    controller: _memoTextEditingController,
                                    decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      labelText: 'ひとこと',
                                      hintText: 'メモ',
                                    ),
                                    onChanged: (text) {
                                      if (text != null && text.length > 20) {
                                        print('20文字超えたらもう無理!');
                                      } else {
                                        _memo = text;
                                        model.refresh();
                                      }
                                    },
                                  ),
                                  // スコア
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Text(
                                              'おすすめ',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      RatingBar.builder(
                                        initialRating: _score.toDouble(),
                                        minRating: 1,
                                        itemSize: 30,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          _score = rating.toInt();
                                          model.refresh();
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Text(
                                              'マイボトル',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: _isMyBottle,
                                        activeColor: Colors.orange,
                                        activeTrackColor: Colors.red,
                                        inactiveThumbColor: Colors.blue,
                                        inactiveTrackColor: Colors.grey,
                                        onChanged: (bool e) {
                                          _isMyBottle = e;
                                          model.refresh();
                                        },
                                      ),
                                    ],
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.image_rounded),
                                TextButton(
                                  child: Text('カメラロール'),
                                  onPressed: () {
                                    model.showImagePicker();
                                    _imageFile = model.imageFile;
                                    model.refresh();
                                  },
                                ),
                                Icon(Icons.photo_album),
                                TextButton(
                                  child: Text('アルバム'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AlbumPage(true),
                                        fullscreenDialog: true,
                                      ),
                                    ).then((value) {
                                      // userImageIdが返ってくる
                                      // 閉じるボタンで閉じた時はuserImageIdがnullなので更新しない
                                      if (value != null) {
                                        _userImageId = value;
                                      }

                                      model.refresh();
                                    });
                                    // _imageFile = model.imageFile;
                                    // model.refresh();
                                  },
                                ),
                                Icon(Icons.broken_image),
                                TextButton(
                                  child: Text('画像リセット'),
                                  onPressed: () {
                                    model.imageFile = null;
                                    _userImageId = null;
                                    model.refresh();
                                  },
                                ),
                              ],
                            ),
                            if (!isEdit)
                              TextButton(
                                child: Text('投稿する'),
                                onPressed: _isAddButtonDisabled
                                    ? null
                                    : () async {
                                        // ローディング開始
                                        model.startLoading();

                                        _name = _name == '' ? 'nullでした' : _name;
                                        DateTime now = DateTime.now();
                                        CoffeeCard addCard = new CoffeeCard(
                                            name: _name,
                                            score: _score,
                                            memo: _memo,
                                            isPublic: _isPublic,
                                            isMyBottle: _isMyBottle,
                                            userImageId: _userImageId,
                                            updatedAt: now,
                                            createdAt: now);
                                        String addCardResult =
                                            await model.addCard(addCard);
                                        if (addCardResult ==
                                            CardModel().validation_error) {
                                          print('バリテーションエラー');
                                        }
                                        // ローディング終了
                                        model.endLoading();

                                        // SNS投稿ダイアログ
                                        // await _showSuccsessDialog(context);

                                        final SnackBar snackBar = SnackBar(
                                          content: Text('投稿が完了しました。'),
                                        );

                                        // 画面戻る
                                        Navigator.of(context).pop(snackBar);
                                      },
                              ),
                            if (isEdit)
                              TextButton(
                                child: Text('更新する'),
                                onPressed: () async {
                                  // ローディング開始
                                  model.startLoading();
                                  CoffeeCard updateCard = new CoffeeCard(
                                      id: _id,
                                      name: _name,
                                      score: _score,
                                      memo: _memo,
                                      isPublic: _isPublic,
                                      userImageId: _userImageId);
                                  final String updateCardResult =
                                      await model.updateCard(updateCard);
                                  // ローディング終了
                                  model.endLoading();

                                  // await _showSuccsessDialog(context);
                                  final SnackBar snackBar = SnackBar(
                                    content: Text('更新が完了しました。'),
                                  );

                                  // 画面戻る
                                  Navigator.of(context).pop(snackBar);
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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

        await Share.file('coffee Image', 'CoffeeProject$nowUnixTime.png',
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
