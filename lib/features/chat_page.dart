import 'dart:io';

import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/message_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('private-message', _listenMessage);

    _loadChat(chatService.userTo.uid);

    super.initState();
  }

  void _listenMessage(dynamic payload) {
    MessageBubble message = MessageBubble(
      message: payload['message'],
      uuid: payload['by'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  void _loadChat(String userId) async {
    List<Message> messages = await chatService.getChat(userId);

    final chat = messages.map((message) => MessageBubble(
          message: message.message,
          uuid: message.by,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 0),
          )..forward(),
        ));


    setState(() {
      _messages.insertAll(0, chat);
    });

  }

  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;

    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black54),
          elevation: 3,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 15,
                child: Text(
                  userTo.name.substring(0, 2),
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                userTo.name,
                style: const TextStyle(color: Colors.black54, fontSize: 15),
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
                  print(_messages);
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
      uuid: authService.user!.uid,
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

    socketService.socket.emit('private-message', {
      'by': authService.user!.uid,
      'to': chatService.userTo.uid,
      'message': message,
    });
  }

  @override
  void dispose() {
    for (MessageBubble message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('private-message');

    super.dispose();
  }
}
