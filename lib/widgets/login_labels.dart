import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '¿No tienes Cuenta?',
          style: TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Text(
            'Crea una ahora!',
            style:
                TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold),
          ),
          onTap: () => Navigator.pushNamed(context, 'register'),
        )
      ],
    );
  }
}
