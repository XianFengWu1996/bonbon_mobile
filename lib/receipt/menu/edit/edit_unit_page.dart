import 'package:bonbon_mobile/components/Cards/unit_option_card.dart';
import 'package:bonbon_mobile/components/Lists/scroll_list_view.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:flutter/material.dart';

class UnitOptionList extends StatelessWidget {
  final List<UnitOption> optionList;
  final Function(UnitOption)? onPressed;
  final String title;
  final Color? color;

  const UnitOptionList({
    Key? key,
    required this.optionList,
    required this.onPressed,
    required this.title,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnitOptionActionTitle(color: color, title: title),
        ScrollListView(
            length: optionList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              UnitOption _unit = optionList[index];
              return UnitOptionCard(
                unit: _unit,
                onPressed: (){
                onPressed!(_unit);
              },
          );})
      ],
    );
  }
}

class UnitOptionActionTitle extends StatelessWidget {
  final Color? color;
  final String title;
  const UnitOptionActionTitle({
    Key? key,
    this.color,
    required this.title
  }) : super(key: key);

  final TextStyle _titleStyle = const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      color: color ?? Colors.green,
      child: Center(
          child: Text(title,
              style: _titleStyle)
      ),
    );
  }
}



