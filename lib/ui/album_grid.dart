import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/userImage.dart';
import 'package:coffee_project/ui/add_or_edit_card_page.dart';
import 'package:coffee_project/utils/date_utility.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:ui' as ui;

class AlbumGrid extends StatelessWidget {
  final String _id;
  final String _userImageId;

  // getter
  String get id => _id;
  String get userImageId => _userImageId;

  AlbumGrid(
    this._id,
    this._userImageId,
  );

  @override
  Widget build(BuildContext context) {
    var list = [
      _photoItem("pic0"),
      _photoItem("pic1"),
      _photoItem("pic2"),
    ];

    return GridView.count(crossAxisCount: 3, children: []);
  }

  Widget _photoItem(String image) {
    var assetsImage = "asset/images/coffeeSample.png";
    return Container(
      child: Image.asset(
        assetsImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
