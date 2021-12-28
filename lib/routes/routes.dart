
import 'package:chat/features/chat_page.dart';
import 'package:chat/features/loading_page.dart';
import 'package:chat/features/login_page.dart';
import 'package:chat/features/register_page.dart';
import 'package:chat/features/users_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'users': (_) => const UsersPage(),
  'chat': (_) => const ChatPage(),
  'login': (_) => const LoginPage(),
  'register': (_) => const RegisterPage(),
  'loading': (_) => const LoadingPage(),

};