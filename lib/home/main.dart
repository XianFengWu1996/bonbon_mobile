import 'package:bonbon_mobile/auth/functionality.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('ran');
    retrieveUnits();
  }

  final List<Map<String, String>> _item = [
    {
      'name': 'Recipe',
      'path': '/recipe'
    },
    {
      'name': 'Receipt',
      'path': '/receipt'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: GridView.count(crossAxisCount: 2,
      children: List.generate(2, (index) {
        return InkWell(
          onTap: (){
            Navigator.pushNamed(context, _item[index]['path']!);
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
