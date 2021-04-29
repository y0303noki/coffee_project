import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/test.dart';
import 'package:coffee_project/ui/list_card.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:coffee_project/view_model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ListCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ListCard> _cardList = [];
    // for (int i = 0; i < 10; i++) {
    //   _cardList.add(
    //     ListCard(
    //       'Coffee $i',
    //       'The best beach in Torrance',
    //       'torrance-beach.jpg',
    //     ),
    //   );
    // }
    //

    // return ListView(children: _cardList);
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: CardModel().findCardList(),
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
    // final record = Record.fromSnapshot(data);
    // final test = Test.fromSnapshot(data);
    final test = Coffee.fromSnapshot(data);
    return Padding(
      key: ValueKey(test.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListCard(
          test.name,
          test.coffeeAt,
          test.memo,
          test.isPublic,
          test.score,
          'The best beach in Torrance',
          'torrance-beach.jpg',
        ),
      ),
    );
  }
}
