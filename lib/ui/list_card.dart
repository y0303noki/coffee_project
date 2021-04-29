import 'package:coffee_project/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ListCard extends StatelessWidget {
  final String _name;
  final DateTime _coffeeDate;
  final String _memo;
  final bool _isPublic;
  final int _score;
  final String _desc;
  final String _picture;

  ListCard(this._name, this._coffeeDate, this._memo, this._isPublic,
      this._score, this._desc, this._picture);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, right: 0, bottom: 0, left: 20),
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
              Padding(
                padding:
                    EdgeInsets.only(top: 10, right: 20, bottom: 0, left: 0),
                child: Chip(
                  avatar: CircleAvatar(
                    backgroundColor: _isPublic != null && _isPublic
                        ? Colors.orange
                        : Colors.blue,
                  ),
                  label: Text(
                      _isPublic != null && _isPublic ? 'Public' : 'Private'),
                ),
              )
            ],
          ),
          Container(
            child: Image.asset('asset/images/coffeeSample.png'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0),
            child: Text(
              '$_name',
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
          Padding(
            padding: EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RatingBarIndicator(
                  rating: _score.toDouble(),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
              ],
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
