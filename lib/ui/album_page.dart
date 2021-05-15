import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/test.dart';
import 'package:coffee_project/model/userImage.dart';
import 'package:coffee_project/ui/album_grid.dart';
import 'package:coffee_project/ui/list_card.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:coffee_project/view_model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CardModel>(
      create: (_) => CardModel(),
      child: Consumer<CardModel>(
        builder: (context, model, child) {
          return GridView.count(crossAxisCount: 2, children: [
            _imageItem(''),
            _imageItem(''),
            _imageItem(''),
          ]);

          ;
        },
      ),
    );
  }

  Widget _imageItem(String name) {
    var image = "asset/images/coffeeSample.png";
    return Container(
      child: Image.asset(
        image,
        fit: BoxFit.cover,
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

    return AlbumGrid(
      test.id,
      userImageId,
    );
  }
}
