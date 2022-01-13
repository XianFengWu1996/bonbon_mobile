import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> _item = [
    {
      'name': 'Receipt',
      'path': '/receipt/home'
    },
  ];

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);

    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () {
            userModel.logout();
          }, icon: const Icon(FontAwesomeIcons.signOutAlt)),
        ],
      ),
      body: GridView.count(crossAxisCount: _item.length,
      children: List.generate(_item.length, (index) {
        return InkWell(
          onTap: () {
            if(_item[index]['path'] == '/receipt/home'){
              receiptModel.retrieveReceiptList();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Center(child: Text(_item[index]['name']!)),
          ),
        );
      }),),
    );
  }
}
