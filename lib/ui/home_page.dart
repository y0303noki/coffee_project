import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/ui/account_page.dart';
import 'package:coffee_project/ui/add_or_edit_card_page.dart';
import 'package:coffee_project/ui/album_page.dart';
import 'package:coffee_project/ui/list_card.dart';
import 'package:coffee_project/ui/list_card_page.dart';
import 'package:coffee_project/ui/setting_page.dart';
import 'package:coffee_project/view_model/card_model.dart';
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
    List<Coffee> home;
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
        backgroundColor: Colors.brown[100],
      ),
      FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.red,
      ),
    ];

    _selectBodyWidget() {
      if (_bottomIndex == 0) {
        return HomeListCoffee(home);
      } else if (_bottomIndex == 1) {
        return AlbumPage(false);
      } else if (_bottomIndex == 2) {
        return SettingPage();
      } else {
        return null;
      }
    }

    return ChangeNotifierProvider<CardModel>(
      create: (_) => CardModel()..findCardListHome(),
      child: Consumer<CardModel>(builder: (context, model, child) {
        home = model.homeCoffee;
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
              // _pageWidgets.elementAt(_bottomIndex),
              // ListCardPage(home),
              _selectBodyWidget(),
            ],
          ),
          // floatingActionButton: _bottomIndex == 0
          //     ? _floatingActionButtons.elementAt(_bottomIndex)
          //     : null,
          floatingActionButton: _bottomIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    // Add your onPressed code here!
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddOrEditCardPage(null),
                        fullscreenDialog: true,
                      ),
                    ).then((value) {
                      model.findCardListHome();
                      model.refresh();
                      home = model.homeCoffee;
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
                  backgroundColor: Colors.brown[100],
                )
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

class HomeListCoffee extends StatelessWidget {
  List<Coffee> homeListCoffees;
  HomeListCoffee(this.homeListCoffees);

  String _searchKeyWord = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<CardModel>(
      builder: (context, model, child) {
        // model.findCardListHome();
        return Column(
          children: [
            // bodyの上部に検索欄などの機能
            // buildFloatingSearchBar(context),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Card(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: "キーワード検索",
                  ),
                  onSubmitted: (term) {
                    // キーボードの検索ボタンを押した時の処理
                    String _termTrimed = term;
                    model.searchKeyword = _termTrimed;
                    model.refresh();
                  },
                ),
              ),
            ),
            Expanded(child: _buildBody(context, model, model.searchKeyword)),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CardModel model, String keyword) {
    homeListCoffees = model.homeCoffee;

    // キーワードが指定されたらフィルターする（部分一致）
    String _keywordTrimed = keyword.trim();
    if (_keywordTrimed.isNotEmpty) {
      _keywordTrimed = _keywordTrimed.toLowerCase();
      homeListCoffees = homeListCoffees
          .where((element) =>
              (element.name.toLowerCase()).contains(_keywordTrimed))
          .toList();
    }

    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: homeListCoffees
          .map((data) => _buildListItem(context, data, model))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Coffee coffee, CardModel model) {
    // キーワード検索
    if (_searchKeyWord.isNotEmpty) {
      String _lowerName = coffee.name.toLowerCase();
      if (!_isContainKeyword(_lowerName, _searchKeyWord)) {
        return Container();
      }
    }
    final String userImageId = coffee.userImageId;

    return Padding(
      key: ValueKey(coffee.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListCard(
            coffee.id,
            coffee.name,
            coffee.coffeeAt,
            coffee.shopOrBrandName,
            coffee.isPublic,
            coffee.score,
            null,
            userImageId,
            false,
            model),
      ),
    );
  }

  Future _showNoCoffeesDialog(BuildContext context) async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('No Coffee'),
        content: new Text('最初の1杯を登録してみましょう'),
        actions: <Widget>[
          new SimpleDialogOption(
            child: new Text('Yes'),
            onPressed: () {
              Navigator.pop(context, 'Yes');
            },
          ),
          new SimpleDialogOption(
            child: new Text('NO'),
            onPressed: () {
              Navigator.pop(context, 'No');
            },
          ),
        ],
      ),
    );
    switch (value) {
      case 'Yes':
        print('YES!!!');
        break;
      case 'No':
        print('No!!!');
        break;
    }
  }

  // キーワード検索
  bool _isContainKeyword(
    String target,
    String query,
  ) {
    return target.contains(query);
  }
}
