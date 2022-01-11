import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final AnimationController animationController;
  final String message;
  final String uuid;

  const MessageBubble(
      {Key? key,
      required this.message,
      required this.uuid,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uuid == authService.user!.uid ? myMessage() : notMyMessage(),
        ),
      ),
    );
  }

  notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 60.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 60.0, bottom: 10.0, right: 10.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
