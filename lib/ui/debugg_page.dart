import 'package:coffee_project/model/user.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// デバッグモード
class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          'デバッグ',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: _buildAccountInfo(context),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    // ログアウト直後に _user を null にしており、_user.photoURLでエラーが出るため分岐させている
    return Column(children: [
      Card(
        child: ListTile(
          trailing: Icon(Icons.arrow_forward_ios),
          title: Text('デバッグ1'),
          onTap: () {},
        ),
      ),
    ]);
  }
}
