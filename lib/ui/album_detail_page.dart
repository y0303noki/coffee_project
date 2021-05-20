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
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                // バツボタン
                IconButton(
                  padding: EdgeInsets.only(top: 60),
                  iconSize: 20,
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Image.network(_imageUrl),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 50),
            child: IconButton(
              iconSize: 50,
              color: Colors.red,
              icon: Icon(Icons.delete_outline_outlined),
              onPressed: () async {
                // 画像をfireStoregeから削除して画面戻る
                await CardModel().deleteUserImageFunc(_imageId);
                final SnackBar snackBar = SnackBar(
                  content: Text('削除が完了しました。'),
                );
                Navigator.of(context).pop(snackBar);
              },
            ),
          ),
        ],
      ),
    );
  }
}
