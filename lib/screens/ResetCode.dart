import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Screens/Login/login_screen.dart';
import 'package:flutter_dashboard/components/common/custom_form_button.dart';
import 'package:flutter_dashboard/components/header.dart';
import 'package:flutter_dashboard/services/userservice.dart';

class RestCodePage extends StatefulWidget {
  final String email;

  const RestCodePage({required this.email});

  UserService get userService => UserService();

  @override
  State<RestCodePage> createState() => _RestCodePageState();
}

class _RestCodePageState extends State<RestCodePage> with SingleTickerProviderStateMixin {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _CpasswordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeader(),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _animation,
                    child: Form(
                      key: _forgetPasswordFormKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _CpasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                hintText: 'Enter your new confirm password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            CustomFormButton(
                              innerText: 'Submit',
                              onPressed: _handleForgetPassword,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleForgetPassword() async {
    if (_forgetPasswordFormKey.currentState!.validate()) {
      try {
        String password = _passwordController.text;

        await widget.userService.newPassword(widget.email, password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset code sent successfully')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );

      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset code. Please try again.'),
          ),
        );
      }
    }
  }
}
