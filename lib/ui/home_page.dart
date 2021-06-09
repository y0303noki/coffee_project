import 'package:coffee_project/ui/account_page.dart';
import 'package:coffee_project/ui/add_or_edit_card_page.dart';
import 'package:coffee_project/ui/album_page.dart';
import 'package:coffee_project/ui/list_card_page.dart';
import 'package:coffee_project/ui/setting_page.dart';
import 'package:coffee_project/view_model/home_model.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ナビゲーションタブインデックス
    int _bottomIndex = 0;
    final _pageWidgets = [
      ListCardPage(),
      AlbumPage(false),
      SettingPage(),
    ];

    final _pageTitles = [
      'ホーム',
      'アルバム',
      '設定',
    ];

    final _floatingActionButtons = [
      FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrEditCardPage(null),
              fullscreenDialog: true,
            ),
          ).then((value) {
            if (value is SnackBar) {
              // 保存が完了したら画面下部に完了メッセージを出す
              ScaffoldMessenger.of(context).showSnackBar(value);
            }
          });
        },
        child: Container(
          width: 50,
          child: Image.asset('asset/images/coffeePlusToukaIcon.png'),
        ),
        backgroundColor: Colors.brown,
      ),
      FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.red,
      ),
    ];

    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel(),
      child: Consumer<HomeModel>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            title: Text(
              _pageTitles.elementAt(_bottomIndex),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: Stack(
            children: [
              _pageWidgets.elementAt(_bottomIndex),
            ],
          ),
          floatingActionButton: _bottomIndex == 0
              ? _floatingActionButtons.elementAt(_bottomIndex)
              : null,
          // フッター とりあえず不要そうなのでコメントアウト
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).canvasColor,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'ホーム',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_album_outlined),
                label: 'アルバム',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: '設定',
              ),
            ],
            currentIndex: _bottomIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (index) {
              // フッターを押して画面切り替え
              _bottomIndex = index;
              model.refresh();
            },
          ),
        );
      }),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await context.read<LoginModel>().logout();
  }
}

class PageWidget extends StatelessWidget {
  final Color color;
  final String title;

  PageWidget({Key key, this.color, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
