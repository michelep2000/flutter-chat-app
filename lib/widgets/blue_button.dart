import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const BlueButton({Key? key, required this.onPressed, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      onPressed: onPressed,
      child:  SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: const StadiumBorder(),
      ),
    );
  }
}
