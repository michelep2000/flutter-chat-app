import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final usersService = UsersService();
  List<User> users = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          user!.name,
          style: const TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
            socketService.disconnect();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.offline_bolt,
              color: socketService.serverStatus == ServerStatus.online
                  ? Colors.blue
                  : Colors.black54,
            ),
          )
        ],
      ),
      body: SmartRefresher(
        header: WaterDropHeader(
          complete: Icon(
            Icons.check_circle,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[200]!,
        ),
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (c, i) => _userListTile(users[i]),
              separatorBuilder: (c, i) => const Divider(),
              itemCount: users.length),
        ),
        onRefresh: _onRefresh,
      ),
    );
  }

  _userListTile(User user) {
    return GestureDetector(
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(
            user.name.substring(0, 2),
          ),
        ),
        trailing: Icon(
          Icons.circle,
          color: user.online! ? Colors.green : Colors.redAccent,
          size: 15,
        ),
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');

      },
    );
  }

  void _onRefresh() async {
    users = await usersService.getUsers();
    _refreshController.refreshCompleted();
    setState(() {});
  }
}
