import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showErrorToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
  );
  Timer(const Duration(seconds: 3), (){
    Fluttertoast.cancel();
  });
}

showSuccessToast(String msg){
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.green,
  );
  Timer(const Duration(seconds: 3), (){
    Fluttertoast.cancel();
  });
}

showUpdateToast(String msg){
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.blue,
  );
  Timer(const Duration(seconds: 3), (){
    Fluttertoast.cancel();
  });
}

showToast(String msg){
  Fluttertoast.showToast(
    msg: msg,
  );
  Timer(const Duration(seconds: 3), (){
    Fluttertoast.cancel();
  });
}