import 'package:coffee_project/ui/add_card_page.dart';
import 'package:coffee_project/ui/list_card_page.dart';
import 'package:coffee_project/view_model/home_model.dart';
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
          );
        },
        child: const Icon(Icons.navigation),
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
            actions: [],
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
