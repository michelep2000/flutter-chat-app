import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  get serverStatus => _serverStatus;

  io.Socket get socket => _socket;

  void connect() async {

    final token = await AuthService.getToken();

    _socket = io.io(
      Environment.socketUrl,
      io.OptionBuilder()
          .enableAutoConnect()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'x-token': token})
          .build(),
    );

    print(_socket);

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      print('connect');
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      print('disconnect');
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
