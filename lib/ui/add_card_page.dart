import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/ui/list_card.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddCardPage extends StatelessWidget {
  final myController = TextEditingController();
  // 指定した日付
  DateTime postDate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          child: ListCard(_name, postDate, memo, _isPublic,
                              _score, 'A', _imageFile, null, true),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          children: [
                            TextField(
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
                              initialRating: 3,
                              minRating: 1,
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
                        child: Text('投稿する'),
                        onPressed: () {
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
                          model.addCard(addCard);
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
    );
  }
}
