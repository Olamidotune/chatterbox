// ignore_for_file: inference_failure_on_function_return_type

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseMethod {
  Future<void> addUserDetails(
    String userId,
    Map<String, dynamic> userInfoMap,
  ) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserByUserEmail(String email) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> searchByName(String userName) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('searchKey', isEqualTo: userName.substring(0, 1).toUpperCase())
        .get();
  }

  createChatRoom(
    String chatRoomId,
    Map<String, dynamic> chatRoomInfoMap,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  // addMessages(
  //   String messageID,
  //   Map<String, dynamic> messageInfoMap,
  //   String chatRoomId,
  // ) async {
  //   return FirebaseFirestore.instance
  //       .collection('chatRoom')
  //       .doc(chatRoomId)
  //       .collection('chats')
  //       .doc(messageID)
  //       .set(messageInfoMap);
  // }

  Future<void> addMessages(
    String messageID,
    Map<String, dynamic> messageInfoMap,
    String chatRoomId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(messageID)
          .set(messageInfoMap);
    } catch (e) {
      debugPrint('Error in addMessages: $e');
      throw e;
    }
  }

  updateLastMessage(
    String chatRoomId,
    Map<String, dynamic> lastMessageInfoMap,
  ) async {
    return FirebaseFirestore.instance
        .collection('chatRooom')
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }
}
