import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/transparent_appbar.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:bonbon_mobile/receipt/menu/edit/edit_menu_item_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditMenu extends StatelessWidget {
  const EditMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MenuModel menuModel = Provider.of<MenuModel>(context);
    return Scaffold(
      appBar: const TransparentAppBar(
        appBarTitle: 'Edit Menu',
        navigatorPath: '/receipt/menu',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/receipt/menu/add');
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
              itemCount: menuModel.menuList.length,
              itemBuilder: (context, index) {
                MenuItem menuItem = menuModel.menuList[index];
                return Card(
                  child: ListTile(
                    trailing: ColorButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return EditMenuItemPage(menuItem: menuItem);
                        }));
                      },
                      label: const Text('Select'),
                    ),
                    title: Text(menuItem.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Available Options: '),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: menuItem.options.length,
                          itemBuilder: (context, index){
                              MenuItemOptions option = menuItem.options[index];
                              return Text(option.flavor);
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}


