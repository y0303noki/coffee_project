import 'package:coffee_project/ui/account_page.dart';
import 'package:coffee_project/ui/add_card_page.dart';
import 'package:coffee_project/ui/list_card_page.dart';
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
      PageWidget(color: Colors.blue, title: 'Album'),
    ];

    final _floatingActionButtons = [
      FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCardPage(),
              fullscreenDialog: true,
            ),
          ).then((value) {
            if (value is SnackBar) {
              // 保存が完了したら画面下部に完了メッセージを出す
              ScaffoldMessenger.of(context).showSnackBar(value);
            }
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
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
          appBar: AppBar(
            title: Text('Coffee'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPage(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  _logout(context);
                },
              ),
            ],
          ),
          body: _pageWidgets.elementAt(_bottomIndex),
          floatingActionButton: _floatingActionButtons.elementAt(_bottomIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'School',
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
