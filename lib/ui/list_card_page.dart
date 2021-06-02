import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/test.dart';
import 'package:coffee_project/model/userImage.dart';
import 'package:coffee_project/ui/list_card.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:coffee_project/view_model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class ListCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _items = ["A", "B", "C"];
    String _selectedItem = "A";
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<CardModel>(
      create: (_) => CardModel(),
      child: Consumer<CardModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              // bodyの上部に検索欄などの機能
              // buildFloatingSearchBar(context),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: "キーワード検索",
                  ),
                  onSubmitted: (term) {
                    // キーボードの検索ボタンを押した時の処理
                    print('DONE!');
                    if (term.isNotEmpty) {
                      model.searchKeyword = term;
                    }
                  },
                ),
              ),
              Expanded(child: _buildBody(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: CardModel().findCardListHome(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final test = Coffee.fromSnapshot(data);
    final String userImageId = test.userImageId;

    return Padding(
      key: ValueKey(test.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListCard(test.id, test.name, test.coffeeAt, test.memo,
            test.isPublic, test.score, null, userImageId, false),
      ),
    );
  }

  Future _showNoCoffeesDialog(BuildContext context) async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('No Coffee'),
        content: new Text('最初の1杯を登録してみましょう'),
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
        break;
      case 'No':
        print('No!!!');
        break;
    }
  }
}
