import 'package:flutter/material.dart';
import '/services/userservice.dart'; // Import your AuthService file
import 'package:flutter_dashboard/responsive.dart';

import '../../components/background.dart';
import 'login_form.dart';
import 'login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  

    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(userService: UserService()),
          desktop: Row(
            children: [
              Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: LoginForm(userService: UserService()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  final UserService userService;

  const MobileLoginScreen({
    Key? key,
    required this.userService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(userService: userService),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
