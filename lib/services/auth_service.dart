import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User? user;
  bool _onAuth = false;
  final _storage = const FlutterSecureStorage();

  bool get onAuth => _onAuth;

  set onAuth(bool value) {
    _onAuth = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    onAuth = true;

    final data = {
      'email': email,
      'password': password,
    };

    final res = await http.post(Uri.parse('${Environment.apiUrl}/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    onAuth = false;
    if (res.statusCode == 200) {
      final loginResponse = loginResponseFromJson(res.body);
      user = loginResponse.user;

      await _saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    onAuth = true;

    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    final res = await http.post(Uri.parse('${Environment.apiUrl}/login/new'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    onAuth = false;

    print(res.body);

    if (res.statusCode == 200) {
      final signUpResponse = loginResponseFromJson(res.body);
      user = signUpResponse.user;

      await _saveToken(signUpResponse.token);

      return true;
    } else {
      final errorMsg = jsonDecode(res.body);
      return errorMsg['msg'];
    }
  }

  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'token');

    final res = await http.get(
      Uri.parse('${Environment.apiUrl}/login/renew-token'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
    );

    onAuth = false;

    if (res.statusCode == 200) {
      final signUpResponse = loginResponseFromJson(res.body);
      user = signUpResponse.user;

      await _saveToken(signUpResponse.token);

      return true;
    } else {
      logout();
      return false;
    }
  }
}
