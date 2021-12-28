import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(isOnline: true, name: 'name1', email: 'name1@test.com', uuid: '1'),
    User(isOnline: false, name: 'name2', email: 'name2@test.com', uuid: '2'),
    User(isOnline: true, name: 'name3', email: 'name3@test.com', uuid: '3'),
    User(isOnline: false, name: 'name4', email: 'name4@test.com', uuid: '4'),
    User(isOnline: true, name: 'name5', email: 'name5@test.com', uuid: '5'),
    User(isOnline: false, name: 'name6', email: 'name6@test.com', uuid: '6')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: const Icon(Icons.offline_bolt,
                color: Colors.blue //Colors.black54,
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
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(
          user.name.substring(0, 2),
        ),
      ),
      trailing: Icon(
        Icons.circle,
        color: user.isOnline ? Colors.green : Colors.redAccent,
        size: 15,
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
