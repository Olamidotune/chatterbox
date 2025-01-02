import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String userLoggedInKey = 'ISLOGGEDIN';
  static String userIDKey = 'USERID';
  static String userNameKey = 'USERNAME';
  static String userEmailKey = 'USEREMAIL';
  static String setProfilePicKey = 'USERPROFILEPIC';
  static String displayUserNameKey = 'DISPLAYUSERNAME';

  // Save data to Shared Preferences
  // ignore: avoid_positional_boolean_parameters
  Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(userLoggedInKey, isUserLoggedIn);
  }

  Future<bool> saveUserIDSharedPreference(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIDKey, userId);
  }

  Future<bool> saveUserNameSharedPreference(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, userEmail);
  }

  Future<bool> saveUserProfilePicSharedPreference(String userProfilePic) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(setProfilePicKey, userProfilePic);
  }

  Future<bool> saveDisplayUserNameSharedPreference(
      String displayUserName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayUserNameKey, displayUserName);
  }

  // Get data from Shared Preferences

  Future<bool?> getUserLoggedInSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  Future<String?> getUserIDSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIDKey);
  }

  Future<String?> getUserNameSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmailSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserProfilePicSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(setProfilePicKey);
  }

  Future<String?> getDisplayUserNameSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayUserNameKey);
  }
}
