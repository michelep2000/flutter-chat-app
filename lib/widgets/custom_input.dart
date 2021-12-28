import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput(
      {Key? key,
      required this.icon,
      required this.hint,
      required this.textController,
      required this.keyboardType,
      required this.isPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2, 5),
                blurRadius: 5)
          ]),
      child: TextField(
        controller: textController,
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
            prefixIcon:  Icon(icon),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: hint),
      ),
    );
  }
}
