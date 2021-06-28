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
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: GestureDetector(
        // 水平方向にスワイプしたら画面を戻す
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 18 || details.delta.dx < -18) {
            Navigator.pop(context);
          }
        },
        // 垂直方向にスワイプしたら画面を戻す
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 25 || details.delta.dy < -25) {
            Navigator.pop(context);
          }
        },

        child: Column(
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  );
                  Navigator.of(context).pop(snackBar);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
