import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/user_dto.dart';
import 'package:coffee_project/ui/account_page.dart';
import 'package:coffee_project/ui/time_picker_page.dart';
import 'package:coffee_project/ui/tutorial_page.dart';
import 'package:coffee_project/utils/date_utility.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:coffee_project/view_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// アカウント情報画面
class SettingPage extends StatelessWidget {
  // 通知時刻
  String notificationTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: ChangeNotifierProvider<UserModel>(
        create: (_) => UserModel(),
        child: Consumer<UserModel>(
          builder: (context, model, child) {
            print(model.notiTime);
            return ListView(
              children: [
                _openAccountPage("アカウント", Icon(Icons.person), context),
                _tutorialPage('チュートリアル', Icon(Icons.book), context),
                _timePickerPage(
                    '通知時刻', Icon(Icons.time_to_leave_outlined), context, model),
                // _settingListItem("通知", Icon(Icons.notifications), null),
              ],
            );
          },
        ),
      ),
    );
  }

  // 設定リストのcontainer
  Container _settingContainer(BuildContext context, String title, Icon icon,
      [String notificationTime]) {
    String notificationTimeStr = '--:--';
    if (notificationTime != null) {
      notificationTimeStr = notificationTime;
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
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
              if (notificationTime != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    notificationTimeStr,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontSize: 15.0),
                  ),
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

  Widget _timePickerPage(
      String title, Icon icon, BuildContext context, UserModel model) {
    return GestureDetector(
      child: _settingContainer(context, title, icon, notificationTime),
      onTap: () async {
        final TimeOfDay t = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (t != null) {
          String userId = LoginModel().user.uid;

          notificationTime = _toHHmm(t);
          print(notificationTime);

          // String _labelText = DateUtility(t).toHm();
          UserDto userDto = new UserDto(
            id: userId,
            notificationAt: notificationTime,
          );
          // model.notiTime = dt;
          model.updateNotificationAt(userDto);
          model.refresh();
          // setState(() {
          //   _labelText = (DateFormat.Hm()).format(dt);
          // });
        }
      },
    );
  }

  // String _notificationStr(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: UserModel().findUserQuerySnapshot(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return '';
  //       return '';

  //       // return _buildList(context, snapshot.data.docs);
  //     },
  //   );
  // }

  DateTime _toDateTime(TimeOfDay t) {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  String _toHHmm(TimeOfDay t) {
    // ゼロ詰めして2桁にする
    String zeroHour =
        t.hour < 10 ? '0${t.hour.toString()}' : '${t.hour.toString()}';
    String zeroMinute =
        t.minute < 10 ? '0${t.minute.toString()}' : '${t.minute.toString()}';

    return '$zeroHour:$zeroMinute';
  }
}
