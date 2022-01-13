import 'package:bonbon_mobile/components/Lists/scroll_list_view.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final void Function()? onTap;
  final MenuItemOptions option;
  final Widget? trailing;
  const OptionCard({
    Key? key,
    required this.onTap,
    required this.option,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTap,
          title: Text(option.flavor, style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),),
          subtitle: ScrollListView(
              length: option.unitOption.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unit: ${option.unitOption[i].unit}'),
                      Text('Price: \$${option.unitOption[i].price.toStringAsFixed(2)}'),
                      option.unitOption.length >  1 && (option.unitOption.length - i) > 1 ? const Divider(
                        color: Colors.black,
                      ) : Container(),
                    ],
                  ),
                );
              }),
          trailing: trailing,
        ),
      ),
    );
  }
}
