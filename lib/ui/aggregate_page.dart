import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/user.dart';
import 'package:coffee_project/view_model/card_model.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// データ集計画面
class AggregatePage extends StatelessWidget {
  int _thisMonthCount = 0;

  // 1杯当たり何Lで計算するか
  final double perLittleCount = 0.25;

  // 1日当たりに何杯飲んでいるか
  double per1dayCount = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CardModel>(
      create: (_) => CardModel()..findThisMonthMyCoffee(),
      child: Consumer<CardModel>(
        builder: (context, model, child) {
          // 作り替えてる途中
          List<Coffee> thisMonthCount = model.thisMonthCoffee;

          if (thisMonthCount.isNotEmpty) {
            _thisMonthCount = thisMonthCount.length;
            _howmanyCount1day();
          }

          // var test = model.findMyAllCoffee();

          // print(test);
          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).canvasColor,
              title: Text(
                '記録',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            body: _buildAccountInfo(context),
          );
        },
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    // ログアウト直後に _user を null にしており、_user.photoURLでエラーが出るため分岐させている
    return Column(
      children: [
        Container(
          width: double.infinity,
          // height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '今月の合計',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          _thisMonthCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 80,
                          ),
                        ),
                      ),
                      Text(
                        '杯',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text('1日当たり${_howmanyCount1day()}杯飲んでいます。'),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          (_thisMonthCount * perLittleCount).toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 80,
                          ),
                        ),
                      ),
                      Text(
                        'L',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '(1杯${perLittleCount}L)',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 1日当たりに何杯飲んでいるか計算
  double _howmanyCount1day() {
    // 四捨五入を少数第一位でするために利用
    final _baseNumber = 10;
    DateTime now = DateTime.now();

    double result = _thisMonthCount / now.day;
    result = ((result * _baseNumber).round() / _baseNumber);

    return result;
  }
}
