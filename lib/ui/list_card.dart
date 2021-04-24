import 'package:coffee_project/utils/date_utility.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String _name;
  final DateTime _coffeeDate;
  final String _memo;
  final String _desc;
  final String _picture;

  ListCard(this._name, this._coffeeDate, this._memo, this._desc, this._picture);

  @override
  Widget build(BuildContext context) {
    String coffeeDateStr = DateUtility(_coffeeDate).toDateFormatted();
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(children: [
            Padding(
              padding: EdgeInsets.only(top: 20, right: 0, bottom: 0, left: 20),
              child: Container(
                child: Text(
                  coffeeDateStr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ]),
          Container(
            child: Image.asset('asset/images/coffeeSample.png'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0),
            child: Text(
              'Coffee $_name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16).copyWith(bottom: 0),
            child: Text(
              _memo,
              style: TextStyle(fontSize: 16),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                child: Text('Buy Cat'),
                onPressed: () {},
              ),
              TextButton(
                child: Text('Buy Cat Food'),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
