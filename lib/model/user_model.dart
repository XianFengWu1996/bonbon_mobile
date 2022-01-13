import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/main.dart';
import 'package:bonbon_mobile/model/dio_config.dart';
import 'package:bonbon_mobile/model/request_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserModel extends ChangeNotifier {
  User _user = User();
  User get user => _user;

  void saveUser (data) {
    _user = User().toObject(data);
    notifyListeners();
  }

  void logout() async {
    try{
      await dioWithToken(_user.token).post(logoutUrl);
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
      final box = GetStorage();
      box.remove('token');
    } catch(e){
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  logIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
      try{
        Response<dynamic> response = await Dio().post(loginUrl, data: {
          "email": email,
          "password": password,
        });
        saveUser(response.data);
        navigatorKey.currentState!.pushNamedAndRemoveUntil('/home', (route) => false);

        // IF USER WANTS TO REMEMBER SAVE IT TO STORAGE, IF NOT REMOVE
        final box = GetStorage();
        if(rememberMe){
          box.write('email', email);
          box.write('token', response.data['token']);
        } else {
          box.remove('token');
        }
      } catch(e){
        showErrorToast(e.toString());
      }
      notifyListeners();
  }

  void logInWithToken(String token) async {
    try {
      Response<dynamic> response = await dioWithToken(token).post(loginTokenUrl);
      saveUser(response.data);
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/home', (route) => false);
    } catch(e){
      showErrorToast(e.toString());
    }

    notifyListeners();
  }

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try{
      Response<dynamic> response = await Dio().post(signupUrl, data: {
        "name": name,
        "email":email,
        "password": password,
      });
      saveUser(response.data);
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/home', (route) => false);
    } catch(e){
      showErrorToast(e.toString());
    }
    notifyListeners();
  }
}

class User {
  String name;
  String email;
  String profilePicture;
  bool emailVerified;
  String token;

  User({
      this.name = '',
      this.email = '',
      this.profilePicture = '',
      this.emailVerified =  false,
      this.token = ''
    });

  User toObject(Map map){
    return User(
      name: map['user']['name'],
      email: map['user']['email'],
      emailVerified: map['user']['email_verified'],
      profilePicture: map['user']['profile_picture'],
      token: map['token']
    );
  }
}
