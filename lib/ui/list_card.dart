import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/userImage.dart';
import 'package:coffee_project/ui/add_or_edit_card_page.dart';
import 'package:coffee_project/ui/album_detail_page.dart';
import 'package:coffee_project/ui/list_card_page.dart';
import 'package:coffee_project/utils/date_utility.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class ListCard extends StatelessWidget {
  final String _id;
  final String _name;
  final DateTime _coffeeDate;
  final String _memo;
  final bool _isPublic;
  final int _score;
  // 端末内の画像のアドレス
  final File _imageFile;
  String _userImageId;
  // True:追加or編集画面 False:リスト画面
  final bool _isAddOrUpdateCard;
  final CardModel _model;

  // getter
  String get id => _id;
  String get name => _name;
  DateTime get coffeeDate => _coffeeDate;
  String get memo => _memo;
  bool get isPublic => _isPublic;
  int get score => _score;
  String get userImageId => _userImageId;

  GlobalKey _globalKey = GlobalKey();
  double _nameFontSize = 1;
  double _memoFontSize = 1;

  ListCard(
      this._id,
      this._name,
      this._coffeeDate,
      this._memo,
      this._isPublic,
      this._score,
      this._imageFile,
      this._userImageId,
      this._isAddOrUpdateCard,
      this._model) {
    // フォントサイズ設定
    if (this._name.length < 10) {
      _nameFontSize = 26;
    } else if (this._name.length >= 10 && this._name.length < 13) {
      _nameFontSize = 23;
    } else if (this._name.length >= 13 && this._name.length < 15) {
      _nameFontSize = 20;
    } else {
      _nameFontSize = 15;
    }

    if (this._memo.length < 10) {
      _memoFontSize = 20;
    } else if (this._memo.length >= 10 && this._memo.length < 13) {
      _memoFontSize = 16;
    } else if (this._memo.length >= 13 && this._memo.length < 15) {
      _memoFontSize = 13;
    } else {
      _memoFontSize = 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    ListCard tempCard = new ListCard(_id, _name, _coffeeDate, _memo, _isPublic,
        _score, _imageFile, _userImageId, _isAddOrUpdateCard, _model);

    String coffeeDateStr = DateUtility(_coffeeDate).toDateFormatted();
    return RepaintBoundary(
      key: _globalKey,
      // child: cardWidget(coffeeDateStr, context, tempCard),
      child: _ticketWidget(coffeeDateStr, context, tempCard, _model),
    );
  }

  // 画像を表示するところ
  // addCardとlistCardで表示する方法が違う
  Widget switchImage() {
    if (_isAddOrUpdateCard) {
      // _userImageIdをnullにしないといけない
      if (_imageFile != null) {
        _userImageId = null;
      }

      // 編集画面
      if (_userImageId != null) {
        return _coffeeImage(_userImageId);
      }

      // 追加画面
      if (_imageFile != null) {
        return Container(
          width: 100,
          height: 100,
          child: Image.file(_imageFile),
        );
      } else {
        return Container(
          width: 100,
          height: 100,
          child: Image.asset('asset/images/coffeeSample.png'),
        );
      }
    } else {
      return _coffeeImage(_userImageId);
    }
  }

  Widget _coffeeImage(String userImageId) {
    return Consumer<CardModel>(builder: (context, model, child) {
      return FutureBuilder(
        // future属性で非同期処理を書く
        future: model.getUserInfo(userImageId),
        // future: chatHelper.getUserInfo(ref.get()),
        builder: (context, snapshot) {
          // 取得完了するまで別のWidgetを表示する
          if (userImageId != null) {
            if (!snapshot.hasData) {
              return Container(
                color: Colors.grey,
                width: 100,
                height: 100,
              );
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> userImageData = snapshot.data.data();
            String imageUrl = null;
            if (userImageData != null) {
              imageUrl = userImageData['imageUrl'];
              return GestureDetector(
                onTap: _isAddOrUpdateCard
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AlbumDetailPage(userImageId, imageUrl),
                            fullscreenDialog: true,
                          ),
                        ).then((value) {
                          if (value is SnackBar) {
                            // 保存が完了したら画面下部に完了メッセージを出す
                            ScaffoldMessenger.of(context).showSnackBar(value);
                            model.refresh();
                          }
                        });
                      },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          }

          return Container(
            width: 100,
            height: 100,
            child: Image.asset('asset/images/coffeeSample.png'),
          );
        },
      );
    });
  }

  // Widgetをimageに変換してByteDataを返す
  Future<ByteData> exportToImage(GlobalKey globalKey) async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;

    // デバッグモードだと失敗することがあるからやり直す
    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 20));
      return exportToImage(globalKey);
    }

    final image = await boundary.toImage(
      pixelRatio: 3,
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData;
  }

  Widget cardWidget(String dateStr, BuildContext context, ListCard listCard) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        // 影
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(10, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          // splashColor: Colors.white,
          // onTap: () => print('tap!'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start, // 上寄せ
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white10),
                    child: switchImage(),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$_name',
                    style: TextStyle(
                      fontSize: _nameFontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  Text(
                    '$dateStr',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  Text(
                    '$_memo',
                    style: TextStyle(
                      fontSize: _memoFontSize,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: _score.toDouble(),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _isAddOrUpdateCard
                            ? null
                            : () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddOrEditCardPage(listCard),
                                    fullscreenDialog: true,
                                  ),
                                ).then((value) {
                                  if (value is SnackBar) {
                                    // 保存が完了したら画面下部に完了メッセージを出す
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(value);
                                  }
                                });
                              },
                        color: Theme.of(context).textTheme.bodyText1.color,
                        icon: Icon(Icons.edit_outlined),
                      ),
                      // SNSで共有ボタン
                      IconButton(
                        onPressed: _isAddOrUpdateCard
                            ? null
                            : () async {
                                final bytes = await exportToImage(_globalKey);
                                final nowUnixTime =
                                    DateTime.now().millisecondsSinceEpoch;

                                await Share.file(
                                    'coffee Image',
                                    'CoffeeProject$nowUnixTime.png',
                                    bytes.buffer.asUint8List(),
                                    'image/png',
                                    text: '今日の1杯を投稿しました！ #CoffeeProject');
                              },
                        color: Theme.of(context).textTheme.bodyText1.color,
                        icon: Icon(Icons.share_outlined),
                      ),
                    ],
                  ),
                  // 編集ボタン
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketWidget(String dateStr, BuildContext context, ListCard listCard,
      CardModel model) {
    // final Widget image = Image.asset('asset/images/coffeeSample.png');
    Widget image = switchImage();

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5),
              child: image,
            ),
          ),
          Container(
            width: 1,
            height: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 5.0),
            color: Colors.grey,
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _name,
                    style: TextStyle(
                      fontSize: _nameFontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _memo,
                    style: TextStyle(
                      fontSize: _memoFontSize,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: _score.toDouble(),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _isAddOrUpdateCard
                            ? null
                            : () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddOrEditCardPage(listCard),
                                    fullscreenDialog: true,
                                  ),
                                ).then((value) {
                                  model.findCardListHome();
                                  model.refresh();
                                  if (value is SnackBar) {
                                    // 保存が完了したら画面下部に完了メッセージを出す
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(value);
                                  }
                                });
                              },
                        color: Theme.of(context).textTheme.bodyText1.color,
                        icon: Icon(Icons.edit_outlined),
                      ),
                      // SNSで共有ボタン
                      IconButton(
                        onPressed: _isAddOrUpdateCard
                            ? null
                            : () async {
                                final bytes = await exportToImage(_globalKey);
                                final nowUnixTime =
                                    DateTime.now().millisecondsSinceEpoch;

                                await Share.file(
                                    'coffee Image',
                                    'CoffeeProject$nowUnixTime.png',
                                    bytes.buffer.asUint8List(),
                                    'image/png',
                                    text: '今日の1杯を投稿しました！ #CoffeeProject');
                              },
                        color: Theme.of(context).textTheme.bodyText1.color,
                        icon: Icon(Icons.share_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
