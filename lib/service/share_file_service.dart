import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ShareFileService extends ChangeNotifier {
  ShareFileService(this.globalKey);
  GlobalKey globalKey;

  Future<void> shareFile(String text) async {
    final bytes = await _exportToImage(globalKey);
    final nowUnixTime = DateTime.now().millisecondsSinceEpoch;

    await Share.file('coffee Image', 'CoffeeProject$nowUnixTime.png',
        bytes.buffer.asUint8List(), 'image/png',
        text: '$text ¥n #CoffeeProject');
  }

  // Widgetをimageに変換してByteDataを返す
  Future<ByteData> _exportToImage(GlobalKey globalKey) async {
    final boundary =
        globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 3,
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData;
  }
}
