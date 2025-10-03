import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user_model.dart';

class AuthController{

  static const String _accessTokenKey = 'token';
  static const String _userModelKey = 'user-data';

  static String? accessToken;
  static UserModel? userModel;

  static  Future<void> saveUserData(UserModel model, String token)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));

    accessToken = token;
    userModel = model;
  }


  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    String? userData = sharedPreferences.getString(_userModelKey);

    if (token != null && userData != null) {
      userModel = UserModel.fromJson(jsonDecode(userData));
      accessToken = token;
    }
  }


  static Future<bool> isUserAlreadyLoggedIn()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    return token!=null;
  }

}