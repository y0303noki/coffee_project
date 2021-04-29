import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/ui/list_card.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
      body: ChangeNotifierProvider<CardModel>(
        create: (_) => CardModel(),
        child: Consumer<CardModel>(builder: (context, model, child) {
          return Container(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child:
                      ListCard(name, postDate, memo, 'A', 'torrance-beach.jpg'),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '名前',
                    hintText: '何飲んだ？',
                  ),
                  onChanged: (text) {
                    // TODO: ここで取得したtextを使う
                    name = text;
                    model.refresh();
                  },
                ),
                Text('メモ'),
                TextField(
                  maxLines: 8,
                  decoration: InputDecoration.collapsed(
                    hintText: 'ひとこと',
                  ),
                  onChanged: (text) {
                    memo = text;
                    model.refresh();
                  },
                ),
                TextButton(
                  child: Text('投稿する'),
                  onPressed: () {
                    name = name == '' ? 'nullでした' : name;
                    DateTime now = DateTime.now();
                    CoffeeCard addCard = new CoffeeCard(name, 10, now,
                        memo: memo, createdAt: now);
                    model.addCard(addCard);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
