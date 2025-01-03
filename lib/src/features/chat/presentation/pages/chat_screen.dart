// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    this.name,
    this.userName,
    this.photoUrl,
  });

  static const String routeName = '/chat';

  String? name;
  String? userName;
  String? photoUrl;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
