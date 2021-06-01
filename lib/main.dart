import 'package:coffee_project/ui/home_page.dart';
import 'package:coffee_project/ui/login_page.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase初期化
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          primaryIconTheme:
              IconThemeData(color: Theme.of(context).textTheme.button.color),
        ),
        darkTheme: ThemeData.dark(),
        // home: HomePage(),
        home: _LoginCheck2(),
        builder: (BuildContext context, Widget child) {
          /// make sure that loading can be displayed in front of all other widgets
          return FlutterEasyLoading(child: child);
        },
      ),
    );
  }
}

// // 新たに追加
// class _LoginCheck extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // ログイン状態に応じて、画面を切り替える
//     bool _loggedIn = context.watch<LoginModel>().loggedIn;
//     print('_loggedIn:$_loggedIn');
//     if (!_loggedIn) {
//       LoginModel().loginTypeTo('ANONUMOUSLY');
//     }
//     return HomePage();
//     // return _loggedIn ? HomePage() : LoginPage();
//   }
// }

class _LoginCheck2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<LoginModel>(context, listen: false)
          .loginTypeTo('ANONUMOUSLY'),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          // 非同期処理未完了 = 通信中
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (dataSnapshot.error != null) {
          // エラー
          return Center(
            child: Text('エラーがおきました'),
          );
        }

        // 成功処理
        return HomePage();
      },
    );
  }
}
