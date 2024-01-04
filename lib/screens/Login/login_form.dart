import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Screens/Forgetpassword.dart';
import 'package:flutter_dashboard/Screens/Signup/components/signup_form.dart';
import 'package:flutter_dashboard/Screens/Signup/signup_screen.dart';
import 'package:flutter_dashboard/dashboard.dart';
import 'package:flutter_dashboard/pages/home/list_user.dart';
import 'package:flutter_dashboard/components/already_have_an_account_acheck.dart';


import '../../constants.dart';

import '/services/userservice.dart'; // Make sure this import points to your UserService file

class LoginForm extends StatefulWidget {
  final UserService userService;

  const LoginForm({
    Key? key,
    required this.userService,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    try {
      await widget.userService.loginUser(
        emailController.text,
        passwordController.text,
      );

      // Navigate to the home screen after successful login
      // Replace with your home screen navigation logic
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoard()),
      );
    
    } catch (error) {
      // Handle login error (show a snackbar, display an error message, etc.)
      print('Login failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Number Phone",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your Password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ), 
          
          
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: login,
            child: Text("Login".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen(userService: widget.userService); // Pass the instance of UserService
                  },
                ),
              );
            },
            
          ),
           // Intégration de la Row dans le widget LoginForm
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>ForgetCodePage()),
                    ),
                    child: const Text(
                      'Forget password?',
                      style: TextStyle(
                        color: Color.fromRGBO(111, 53, 165, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SignUpForm(userService: widget.userService),
                      ),
                    );
                  },
                  child: Text(
                    '',
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}

