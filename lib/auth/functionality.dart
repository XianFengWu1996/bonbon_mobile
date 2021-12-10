import 'package:bonbon_mobile/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void logIn({
  required bool validate,
  required String email,
  required String password,
  required Function saveUser,
  required BuildContext context
}) async {
  if(validate){
    try{
      Response<dynamic> response = await Dio().post('http://localhost:3000/login', data: {
        "email": email,
        "password": password,
      });

      var userData = response.data['user'];

      saveUser(
          name: userData['name'],
          email: userData['email'],
          profPic: userData['profile_picture'],
          emailVerified: userData['email_verified'],
          token: response.data['token']
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    } on DioError catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.response!.data['error'])));
    } catch(e){
      print(e);
    }

  }

}

void signUp({
  required bool validate,
  required bool allowToProceed,
  required String name,
  required String email,
  required String password,
  required Function saveUser,
  required BuildContext context
}) async {
  if(validate){
    if(allowToProceed){
      try{
        Response<dynamic> response = await Dio().post('http://localhost:3000/signup',
            data: {
              "name": name,
              "email":email,
              "password": password,
            });

        var userData = response.data['user'];

        saveUser(
            name: userData['name'],
            email: userData['email'],
            profPic: userData['profile_picture'],
            emailVerified: userData['email_verified'],
            token: response.data['token']
        );

        print('your are registered');
      } on DioError catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.response!.data['error'])));
      } catch(e) {
        print(e);
      }
    }
  }
}

void retrieveUnits() async {
  UserModel userModel = UserModel();
  Response response = await Dio().get('http://localhost:3000/units',options: Options(
    headers: {
      'Authorization': 'Bearer ${userModel.user.token}'
    }
  ));

  print(response.data);
}