import 'package:bonbon_mobile/Auth/login.dart';
import 'package:bonbon_mobile/Auth/signup.dart';
import 'package:bonbon_mobile/home/main.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/home/main.dart';
import 'package:bonbon_mobile/receipt/menu/edit/add_menu_item_page.dart';
import 'package:bonbon_mobile/receipt/menu/edit/main.dart';
import 'package:bonbon_mobile/receipt/menu/main.dart';
import 'package:bonbon_mobile/receipt/review/main.dart';
import 'package:bonbon_mobile/receipt/preview/main.dart';
import 'package:bonbon_mobile/recipe/main.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'model/user_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await GetStorage.init();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProxyProvider<UserModel,MenuModel>(
        create: (_) => MenuModel(),
        update: (_, user, menu) => menu!..token = user.user.token,
      ),
      ChangeNotifierProxyProvider<UserModel, ReceiptModel>(
        create: (_) => ReceiptModel(),
        update: (_, user, receipt) => receipt!..token = user.user.token,
      )
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
      navigatorKey: navigatorKey,
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/home': (context) => const Home(),
        '/recipe': (context) =>  const Recipe(),
        '/receipt/home': (context) => const ReceiptHome(),
        '/receipt/menu': (context) => const ReceiptMenu(),
        '/receipt/menu/edit': (context) => const EditMenu(),
        '/receipt/menu/add': (context) => const AddMenuItem(),
        '/receipt/review': (context) =>  const ReceiptReview(),
        '/receipt/preview': (context) => const ReceiptPreview(),
      },
    );
  }
}
