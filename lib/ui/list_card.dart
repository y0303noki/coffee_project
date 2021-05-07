import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_project/ui/add_or_edit_card_page.dart';
import 'package:coffee_project/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:ui' as ui;

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

  GlobalKey _globalKey = GlobalKey();

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
    return RepaintBoundary(
      key: _globalKey,
      child: cardWidget(coffeeDateStr, context, tempCard

          //   clipBehavior: Clip.antiAlias,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(24),
          //   ),
          //   child: Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Stack(
          //             children: [
          //               Container(
          //                 width: 200.0,
          //                 height: 200.0,
          //                 child: switchImage(),
          //               ),
          //               Padding(
          //                 padding: EdgeInsets.only(
          //                     top: 10, right: 0, bottom: 0, left: 20),
          //                 child: Container(
          //                   child: Text(
          //                     coffeeDateStr,
          //                     style: TextStyle(
          //                       color: Colors.red,
          //                       fontSize: 20,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           // TODO:公開設定、一旦表示しない
          //           // Padding(
          //           //   padding:
          //           //       EdgeInsets.only(top: 10, right: 20, bottom: 0, left: 0),
          //           //   child: Chip(
          //           //     avatar: CircleAvatar(
          //           //       backgroundColor: _isPublic != null && _isPublic
          //           //           ? Colors.orange
          //           //           : Colors.blue,
          //           //     ),
          //           //     label: Text(
          //           //         _isPublic != null && _isPublic ? 'Public' : 'Private'),
          //           //   ),
          //           // ),
          //         ],
          //       ),
          //       // Image.file(_imageFile),

          //       Padding(
          //         padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0),
          //         child: Text(
          //           '$_name',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //             fontSize: 24,
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: EdgeInsets.all(16).copyWith(bottom: 0),
          //         child: Text(
          //           _memo,
          //           style: TextStyle(fontSize: 16),
          //         ),
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             RatingBarIndicator(
          //               rating: _score.toDouble(),
          //               itemBuilder: (context, index) => Icon(
          //                 Icons.star,
          //                 color: Colors.amber,
          //               ),
          //               itemCount: 5,
          //               itemSize: 20.0,
          //               direction: Axis.horizontal,
          //             ),
          //           ],
          //         ),
          //       ),
          //       switchButtonBar(context, tempCard),
          //     ],
          //   ),
          // ),
          ),
    );
  }

  // 画像を表示するところ
  // addCardとlistCardで表示する方法が違う
  Widget switchImage() {
    if (_isAddCard) {
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
        // return Image.asset('asset/images/coffeeSample.png');
      }
    } else {
      if (_imageUrl != null) {
        return Container(
          width: 100,
          height: 100,
          child: Image.network(_imageUrl),
        );
        // return Image.network(_imageUrl);
      } else {
        return Container(
          width: 100,
          height: 100,
          child: Image.asset('asset/images/coffeeSample.png'),
        );
        // return Image.asset('asset/images/coffeeSample.png');
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
              final bytes = await exportToImage(_globalKey);
              final nowUnixTime = DateTime.now().millisecondsSinceEpoch;

              await Share.file('coffee Image', 'CoffeeProject$nowUnixTime.png',
                  bytes.buffer.asUint8List(), 'image/png',
                  text: '今日の1杯を投稿しました！ #CoffeeProject');
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
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Color(0x80000000),
            offset: Offset(0, 4),
            blurRadius: 6,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Color(0x30f010f0),
          onTap: () => print('tap!'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: switchImage(),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    '$_name',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff333333),
                    ),
                  ),
                  Text(
                    '$dateStr',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$_memo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff333333),
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
                      // SNSで共有ボタン
                      IconButton(
                        onPressed: () async {
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
                        color: Colors.blue,
                        icon: Icon(Icons.share),
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
}
