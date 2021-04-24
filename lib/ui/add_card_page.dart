import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddCardPage extends StatelessWidget {
  final myController = TextEditingController();
  // 指定した日付
  DateTime postDate = DateTime.now();
  // 名前
  String name = '';
  // メモ
  String memo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('投稿'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(postDate.toString()),
            TextField(
              decoration: InputDecoration(
                hintText: '名前',
              ),
              onChanged: (text) {
                // TODO: ここで取得したtextを使う
                name = text;
              },
            ),
            TextField(
              maxLines: 8,
              decoration: InputDecoration.collapsed(hintText: 'ひとこと'),
              onChanged: (text) {
                memo = text;
              },
            ),
            TextButton(
              child: Text('投稿する'),
              onPressed: () {
                name = name == '' ? 'nullでした' : name;
                DateTime now = DateTime.now();
                CoffeeCard addCard =
                    new CoffeeCard(name, 10, now, memo: memo, createdAt: now);

                CardModel().addCard(addCard);
              },
            ),
          ],
        ),
      ),
    );
  }
}
