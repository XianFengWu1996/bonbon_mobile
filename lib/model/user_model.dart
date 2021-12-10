import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User _user = User(name: '', email: '', profilePicture: '', emailVerified: false, token: '');

  User get user => _user;

  void saveUser ({name, email, profPic, emailVerified, token}) {
    _user = User(
        name: name,
        email: email,
        profilePicture: profPic,
        emailVerified: emailVerified,
        token: token
    );
    notifyListeners();
  }
}

class User {
  String name;
  String email;
  String profilePicture;
  bool emailVerified;
  String token;

  User(
      {required this.name,
      required this.email,
      required this.profilePicture,
      required this.emailVerified,
      required this.token});
}
