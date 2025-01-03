import 'package:cloud_firestore/cloud_firestore.dart';

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
}
