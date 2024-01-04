import 'package:flutter/material.dart';

class CustomFormButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  const CustomFormButton({Key? key, required this.innerText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 3,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 43, 2, 41),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(innerText, style: const TextStyle(color: Colors.white, fontSize: 40),),
      ),
    );
  }
}
