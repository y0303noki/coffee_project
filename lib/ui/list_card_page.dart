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

class ListCardPage extends StatelessWidget {
  List<Coffee> homeCoffees;
  ListCardPage(this.homeCoffees);

  String _searchKeyWord = '';

  @override
  Widget build(BuildContext context) {
    print('Go!');
    // List<String> _items = ["A", "B", "C"];
    // String _selectedItem = "A";
    // final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<CardModel>(
      create: (_) => CardModel()..findCardListHome(),
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
                    String _termTrimed = term.trim();
                    if (term.isNotEmpty) {
                      _searchKeyWord = _termTrimed;
                      model.refresh();
                    } else {
                      _searchKeyWord = '';
                    }
                  },
                ),
              ),
              Expanded(child: _buildBody(context, model)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CardModel model) {
    homeCoffees = model.homeCoffee;
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          homeCoffees.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Coffee coffee) {
    // キーワード検索
    if (_searchKeyWord.isNotEmpty) {
      String _lowerName = coffee.name.toLowerCase();
      if (!_isContainKeyword(_lowerName, _searchKeyWord)) {
        return Container();
      }
    }
    final String userImageId = coffee.userImageId;

    return Padding(
      key: ValueKey(coffee.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListCard(coffee.id, coffee.name, coffee.coffeeAt, coffee.memo,
            coffee.isPublic, coffee.score, null, userImageId, false),
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

  // キーワード検索
  bool _isContainKeyword(
    String target,
    String query,
  ) {
    return target.contains(query);
  }
}
