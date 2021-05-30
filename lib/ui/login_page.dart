import 'package:coffee_project/view_model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: Text('ログイン'),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: _buildSocialLogin(context),
    );
  }

  Future<void> _login(BuildContext context) async {
    bool loggedIn = false;
    EasyLoading.show(status: 'loading...');
    if (await context.read<LoginModel>().loginTypeTo('ANONUMOUSLY')) {
      loggedIn = true;
    }
    EasyLoading.dismiss();
    return loggedIn;
  }

  Center _buildSocialLogin(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SignInButton(
            buttonType: ButtonType.apple,
            onPressed: () {},
          ),
          SignInButton(
            buttonType: ButtonType.google,
            onPressed: () async {
              await context.read<LoginModel>().loginTypeTo('GOOGLE');
            },
          ),
          TextButton(
            child: const Text('匿名ログイン'),
            onPressed: () async {
              await _login(context);
              await context.read<LoginModel>().loginTypeTo('ANONUMOUSLY');
            },
          ),
        ],
      ),
    );
  }
}
