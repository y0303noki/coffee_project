import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// アカウント情報画面
class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: _buildAccountInfo(context),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    final User _user = context.select((LoginModel _auth) => _auth.user);

    // ログアウト直後に _user を null にしており、_user.photoURLでエラーが出るため分岐させている
    return Column(children: [
      _user != null
          ? Card(
              child: ListTile(
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(_user.photoURL ?? ''),
                // ),
                // title: Text(_user.displayName),
                // subtitle: Text(_user.email),
                title: Text(_user.uid),
                subtitle: Text('email'),
              ),
            )
          : Container(),
      _user != null
          ? Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('ログアウト'),
                onTap: () {
                  _logout(context);
                },
              ),
            )
          : Container(),
    ]);
  }

  // ログアウトする
  Future<void> _logout(BuildContext context) async {
    await context.read<LoginModel>().logout();
    // 初期画面に戻る
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
