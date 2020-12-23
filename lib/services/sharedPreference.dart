import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static String sharedPreferenceUsernameKey = "USERNAMEKEY";
  static String sharedPreferenceLoggedInUserKey = "ISLOGGEDIN";
  static String sharedPreferenceEmailKey = "EMALIKEY";

  // saving Data using sharedPreference

  static Future<void> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceLoggedInUserKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUsernameKey, userName);
  }

  static Future<void> saveUserEmailSharedPreference(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUsernameKey, email);
  }

  //Getting data from saved SharedPreference

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceLoggedInUserKey);
  }

  static Future<String> getUsernameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUsernameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceEmailKey);
  }
}
