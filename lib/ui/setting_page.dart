import 'package:coffee_project/ui/account_page.dart';
import 'package:coffee_project/ui/aggregate_page.dart';
import 'package:coffee_project/ui/tutorial_page.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// アカウント情報画面
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: ListView(children: [
        _openAccountPage("アカウント", Icon(Icons.person), context),
        _tutorialPage('チュートリアル', Icon(Icons.book), context),
        _openAggregatePage('集計', Icon(Icons.list), context),

        // _settingListItem("通知", Icon(Icons.notifications), null),
      ]),
    );
  }

  // 設定リストのcontainer
  Container _settingContainer(BuildContext context, String title, Icon icon) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: icon,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 18.0),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  // アカウントページを開く
  Widget _openAccountPage(String title, Icon icon, BuildContext context) {
    return GestureDetector(
      child: _settingContainer(context, title, icon),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountPage(),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  // チュートリアル画面を開く
  Widget _tutorialPage(String title, Icon icon, BuildContext context) {
    return GestureDetector(
      child: _settingContainer(context, title, icon),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialPage(),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  // 集計画面を開く
  Widget _openAggregatePage(String title, Icon icon, BuildContext context) {
    return GestureDetector(
      child: _settingContainer(context, title, icon),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AggregatePage(),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }
}
