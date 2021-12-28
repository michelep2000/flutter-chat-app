import 'dart:io';

import 'package:chat/widgets/message_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _messages = [];

  final _messageController = TextEditingController();

  final _messageFocusNode = FocusNode();

  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 3,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: const Text(
                  'Te',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Text(
                'Name Surname',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (c, i) {
                  return _messages[i];
                },
              ),
            ),
            _inputChat()
          ],
        ));
  }

  _inputChat() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SafeArea(
          child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _messageController,
              onSubmitted: _handleSubmit,
              onChanged: (String text) {
                setState(() {
                  if (text.trim().isNotEmpty) {
                    isWriting = true;
                  } else {
                    isWriting = false;
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                  hintText: 'Type a message', fillColor: Colors.white),
              focusNode: _messageFocusNode,
            ),
          ),
          Platform.isIOS
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CupertinoButton(
                    child: const Text(
                      'Send',
                    ),
                    onPressed: isWriting
                        ? () => _handleSubmit(_messageController.text.trim())
                        : null,
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: const IconThemeData(color: Colors.blue),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                      ),
                      onPressed: isWriting
                          ? () => _handleSubmit(_messageController.text.trim())
                          : null,
                    ),
                  ),
                )
        ],
      )),
    );
  }

  _handleSubmit(String message) {
    if (message.isEmpty) return;

    final newMessage = MessageBubble(
      message: message,
      uuid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    _messageController.clear();
    _messageFocusNode.requestFocus();
    setState(() => isWriting = false);
  }

  @override
  void dispose() {
    for (MessageBubble message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
