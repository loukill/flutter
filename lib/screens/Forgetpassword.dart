import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Screens/Login/login_form.dart';
import 'package:flutter_dashboard/Screens/validationCode.dart';
import 'package:flutter_dashboard/components/common/custom_form_button.dart';
import 'package:flutter_dashboard/components/header.dart';
import 'package:flutter_dashboard/services/userservice.dart';

class ForgetCodePage extends StatefulWidget {
  const ForgetCodePage({Key? key}) : super(key: key);

  UserService get userService => UserService();

  @override
  State<ForgetCodePage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetCodePage>
    with SingleTickerProviderStateMixin {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
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
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: 'Enter your number phone',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                            
                            CustomFormButton(
                              innerText: 'Submit',
                              onPressed: _handleForgetPassword,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginForm(
                                          userService: widget.userService,
                                        )),
                              ),
                              child: const Text(
                                '',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Color.fromRGBO(111, 53, 165, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
      String userEmail = _emailController.text;
      await widget.userService.sendResetCode(userEmail);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset code sent successfully')),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetCodePageP()),
         
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


  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
