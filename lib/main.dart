import 'package:bonbon_mobile/Auth/login.dart';
import 'package:bonbon_mobile/Auth/signup.dart';
import 'package:bonbon_mobile/home/main.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/main.dart';
import 'package:bonbon_mobile/receipt/receipt_display.dart';
import 'package:bonbon_mobile/recipe/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/user_model.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => ReceiptModel()),
    ],
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      initialRoute: '/receipt',
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/home': (context) => const Home(),
        '/recipe': (context) =>  const Recipe(),
        '/receipt': (context) => const Receipt(),
        '/receipt/display': (context) => const ReceiptDisplay(),
      },
    );
  }
}
