import 'package:flutter/material.dart';
import 'package:gafemp/model/user_gaf.dart';

class MessagePage extends StatefulWidget {
  final UserGaf user;
  MessagePage(this.user, {Key key}) : super(key: key);
  @override
  _MessagePageState createState() => _MessagePageState(user);
}

class _MessagePageState extends State<MessagePage> {
  UserGaf user;
  _MessagePageState(this.user);

  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    TextField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
