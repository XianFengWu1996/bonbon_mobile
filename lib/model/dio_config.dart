
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

Dio dioWithToken(String token){
  Dio dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers = {
          'Authorization': 'Bearer $token',
        };
        return handler.next(options);
      },
      onError: (DioError error, handler){
        // todo add more handling to detect jwt error
        if(error.response!.statusCode == 401){
          final box = GetStorage();
          box.remove('token');
          navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
          showDialog(context: navigatorKey.currentContext!, builder: (context){
            return const AlertDialog(
              title: Text('请重新登陆'),
            );
          });
          return;
        }
        print(error.response!.data['error']);
        showErrorToast(error.response!.data['error'] ?? 'Unexpected Error Occurred');
        return handler.next(error);
      }
    )
  );

  return dio;
}
