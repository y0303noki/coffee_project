import 'dart:io';

import 'package:coffee_project/ui/add_or_edit_card_page.dart';
import 'package:coffee_project/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share/share.dart';

class ListCard extends StatelessWidget {
  final String _name;
  final DateTime _coffeeDate;
  final String _memo;
  final bool _isPublic;
  final int _score;
  final String _desc;
  // 端末内の画像のアドレス
  final File _imageFile;
  // アップロード済みの画像のアドレス
  final String _imageUrl;
  // True:追加画面 False:リスト画面
  final bool _isAddCard;

  // getter
  String get name => _name;
  DateTime get coffeeDate => _coffeeDate;
  String get memo => _memo;
  bool get isPublic => _isPublic;
  int get score => _score;
  String get imageUrl => _imageUrl;

  ListCard(
      this._name,
      this._coffeeDate,
      this._memo,
      this._isPublic,
      this._score,
      this._desc,
      this._imageFile,
      this._imageUrl,
      this._isAddCard);

  @override
  Widget build(BuildContext context) {
    ListCard tempCard = new ListCard(_name, _coffeeDate, _memo, _isPublic,
        _score, _desc, _imageFile, _imageUrl, _isAddCard);

    String coffeeDateStr = DateUtility(_coffeeDate).toDateFormatted();
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, right: 0, bottom: 0, left: 20),
                child: Container(
                  child: Text(
                    coffeeDateStr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              // TODO:公開設定、一旦表示しない
              // Padding(
              //   padding:
              //       EdgeInsets.only(top: 10, right: 20, bottom: 0, left: 0),
              //   child: Chip(
              //     avatar: CircleAvatar(
              //       backgroundColor: _isPublic != null && _isPublic
              //           ? Colors.orange
              //           : Colors.blue,
              //     ),
              //     label: Text(
              //         _isPublic != null && _isPublic ? 'Public' : 'Private'),
              //   ),
              // ),
            ],
          ),
          // Image.file(_imageFile),
          Container(
            width: 200.0,
            height: 200.0,
            child: switchImage(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0),
            child: Text(
              '$_name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16).copyWith(bottom: 0),
            child: Text(
              _memo,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
          switchButtonBar(context, tempCard),
        ],
      ),
    );
  }

  // 画像を表示するところ
  // addCardとlistCardで表示する方法が違う
  Widget switchImage() {
    if (_isAddCard) {
      if (_imageFile != null) {
        return Image.file(_imageFile);
      } else {
        return Image.asset('asset/images/coffeeSample.png');
      }
    } else {
      if (_imageUrl != null) {
        return Image.network(_imageUrl);
      } else {
        return Image.asset('asset/images/coffeeSample.png');
      }
    }
  }

  // 共有ボタンと編集ボタン
  Widget switchButtonBar(BuildContext context, ListCard listCard) {
    if (_isAddCard) {
      return ButtonBar();
    } else {
      return ButtonBar(
        alignment: MainAxisAlignment.start,
        children: [
          // SNSで共有ボタン
          IconButton(
            onPressed: () async {
              await Share.share("ここに共有したい文字列");
            },
            color: Colors.blue,
            icon: Icon(Icons.share),
          ),
          // 編集ボタン
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrEditCardPage(listCard),
                  fullscreenDialog: true,
                ),
              ).then((value) {
                if (value is SnackBar) {
                  // 保存が完了したら画面下部に完了メッセージを出す
                  ScaffoldMessenger.of(context).showSnackBar(value);
                }
              });
            },
            color: Colors.blue,
            icon: Icon(Icons.edit),
          ),
        ],
      );
    }
  }
}
