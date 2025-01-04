// ignore_for_file: must_be_immutable

import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/core/extentions/num_extention.dart';
import 'package:chatterbox/src/features/authentication/services/database.dart';
import 'package:chatterbox/src/services/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

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
  final TextEditingController _messageController = TextEditingController();
  String? myUserName;
  String? myPhotoUrl;
  String? myName;
  String? myEmail;
  String? messageID;
  String? chatRoomId;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  String getChatRoomIDByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '${b}_$a';
    } else {
      return '${a}_$b';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.name ?? 'User Name',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Message $index',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.search,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.fontSize,
                            color: AppColors.primaryTextColor,
                          ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor.withOpacity(0.2),
                        hintText: AppStrings.message,
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.greyColor,
                                  fontSize: 15.fontSize,
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.greenColor),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.horizontalSpace(8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: () {
                        addMessage(true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void addMessage(bool isClicked) {
  //   if (_messageController.text.isNotEmpty) {
  //     final message = _messageController.text;
  //     _messageController.text = '';

  //     final now = DateTime.now();
  //     final formattedTime = DateFormat('h:mma').format(now);
  //     final messageInfoMap = {
  //       'message': message,
  //       'sendBy': myUserName,
  //       'timeStamp': formattedTime,
  //       'time': FieldValue.serverTimestamp(),
  //       'photoUrl': myPhotoUrl,
  //     };

  //     if (messageID == null || messageID!.isEmpty) {
  //       messageID = randomAlphaNumeric(10);
  //     }

  //     DatabaseMethod()
  //         .addMessages(messageID!, messageInfoMap, chatRoomId!)
  //         .then((value) {
  //       final lastMessageInfoMap = {
  //         'lastMessage': message,
  //         'timeStamp': formattedTime,
  //         'time': FieldValue.serverTimestamp(),
  //         'lastMessageSendBy': myUserName,
  //       };

  //       debugPrint('Here:$lastMessageInfoMap');
  //       debugPrint('Here:$messageID');

  //       DatabaseMethod().updateLastMessage(
  //         chatRoomId!,
  //         lastMessageInfoMap,
  //       );
  //       if (isClicked) {
  //         messageID = '';
  //       }
  //     });
  //   }
  // }

  void addMessage(bool isClicked) async {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      _messageController.text = '';

      final now = DateTime.now();
      final formattedTime = DateFormat('h:mma').format(now);

      // First, check if chatRoomId is not null
      if (chatRoomId == null) {
        debugPrint('Error: chatRoomId is null');
        return;
      }

      // Check if the chat room exists
      final chatRoomDoc = await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .get();

      // If chat room doesn't exist, create it
      if (!chatRoomDoc.exists) {
        await FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(chatRoomId)
            .set({
          'createdAt': FieldValue.serverTimestamp(),
          'participants': [myUserName], // Add relevant participants
        });
      }

      final messageInfoMap = {
        'message': message,
        'sendBy': myUserName,
        'timeStamp': formattedTime,
        'time': FieldValue.serverTimestamp(),
        'photoUrl': myPhotoUrl,
      };

      // Generate a new messageID if null or empty
      messageID ??= randomAlphaNumeric(10);

      try {
        await DatabaseMethod()
            .addMessages(messageID!, messageInfoMap, chatRoomId!);
        final lastMessageInfoMap = {
          'lastMessage': message,
          'timeStamp': formattedTime,
          'time': FieldValue.serverTimestamp(),
          'lastMessageSendBy': myUserName,
        };

        // Update the chat room with last message info
        await FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(chatRoomId)
            .update(lastMessageInfoMap);

        debugPrint('Message sent successfully');
      } catch (e) {
        debugPrint('Error sending message: $e');
      }
    }
  }

  Future<void> getSharedPrefs() async {
    myEmail = await SharedPrefs().getUserEmailSharedPreference();
    myName = await SharedPrefs().getUserNameSharedPreference();
    myPhotoUrl = await SharedPrefs().getUserProfilePicSharedPreference();
    myUserName = await SharedPrefs().getUserNameSharedPreference();

    chatRoomId = getChatRoomIDByUsername(widget.userName!, myUserName!);
  }
}
