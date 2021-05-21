import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/userImage.dart';
import 'package:coffee_project/ui/album_detail_page.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatelessWidget {
  bool _isAddorUpdatePage;
  AlbumPage(this._isAddorUpdatePage);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CardModel>(
      create: (_) => CardModel(),
      child: Consumer<CardModel>(
        builder: (context, model, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _isAddorUpdatePage
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 50, 0, 0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('閉じる'),
                          )
                        ],
                      ),
                    )
                  : Container(),
              _buildBody(context),
            ],
          );
          // return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: CardModel().findUserImageByUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Center(
          child: Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.lime,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '画像を追加するとここに表示されます',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // DBから取得した値を変換
    List<UserImage> userImageList = [];
    for (DocumentSnapshot snap in snapshot) {
      userImageList.add(
        _buildListItem(snap),
      );
    }

    // Widgetに変換
    List<Widget> userImageWidget = [];
    for (UserImage userImage in userImageList) {
      userImageWidget.add(
        _photoItem(context, userImage.id, userImage.imageUrl),
      );
    }

    return GridView.count(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: userImageWidget,
    );
  }

  Widget _photoItem(BuildContext context, String imageId, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              if (_isAddorUpdatePage) {
                // アルバムから設定
                Navigator.of(context).pop(imageId);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumDetailPage(imageId, imageUrl),
                    fullscreenDialog: true,
                  ),
                ).then((value) {
                  if (value is SnackBar) {
                    // 保存が完了したら画面下部に完了メッセージを出す
                    ScaffoldMessenger.of(context).showSnackBar(value);
                  }
                });
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  UserImage _buildListItem(DocumentSnapshot data) {
    final userImage = UserImage.fromSnapshot(data);
    return userImage;
  }
}
