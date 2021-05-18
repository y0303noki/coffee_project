import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/userImage.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AlbumDetailPage extends StatelessWidget {
  String _imageId;
  String _imageUrl;
  AlbumDetailPage(this._imageId, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<CardModel>(
    //   create: (_) => CardModel(),
    //   child: Consumer<CardModel>(
    //     builder: (context, model, child) {
    //       return Center(
    //         child: Image.network(_imageUrl),
    //       );
    //     },
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('画像'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Center(
            child: Image.network(_imageUrl),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      iconSize: 50,
                      color: Colors.pink,
                      icon: Icon(Icons.favorite),
                      onPressed: () {},
                    ),
                    Text(
                      'お気に入り',
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      iconSize: 50,
                      color: Colors.red,
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        CardModel().deleteUserImageFunc(_imageId);
                      },
                    ),
                    Text(
                      '削除',
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
