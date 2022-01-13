import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:bonbon_mobile/components/Cards/add_option_card.dart';
import 'package:bonbon_mobile/components/Cards/option_card.dart';
import 'package:bonbon_mobile/components/Lists/scroll_list_view.dart';
import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/components/transparent_appbar.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({Key? key}) : super(key: key);

  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final TextEditingController _name = TextEditingController();
  bool showNewOptionCard = false;

  final List<MenuItemOptions> _optionList = [];

  @override
  Widget build(BuildContext context) {

    onSave(startLoading, stopLoading, btnState,flavor, unitOptionList) async {
      if(flavor.isEmpty){
        showErrorToast('Flavor can not be empty');
        return;
      }

      if(unitOptionList.isEmpty){
        showErrorToast('Must have at least one option for unit');
        return;
      }

      if(btnState == ButtonState.Idle) {
        startLoading();

        int index = _optionList.indexWhere((element) => element.flavor == flavor);
        if(index == -1){
          setState(() {
            _optionList.add(MenuItemOptions(flavor: flavor, unitOption: unitOptionList));

            showNewOptionCard = false;
          });
        } else {
          showErrorToast('Duplicate flavor not allow');
        }

        stopLoading();
      }
    }

    MenuModel menuModel = Provider.of<MenuModel>(context);
    return  Scaffold(
      appBar: TransparentAppBar(
        navigatorPath: '/receipt/menu/edit',
        appBarTitle: 'Add Menu Item',
        actions: [
          TextButton(onPressed: (){
            menuModel.addMenuItem(_name.text, _optionList);
          }, child: const Text('SAVE')),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              AuthInput(
                  icon: FontAwesomeIcons.pen,
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
                  label: 'Name',
                  controller: _name),
              ScrollListView(
                  length: _optionList.length,
                  itemBuilder: (context, index){
                    return OptionCard(
                        onTap: null,
                        option: _optionList[index],
                        trailing: IconButton(
                          icon: const Icon(FontAwesomeIcons.times, color: Colors.red,),
                          onPressed: (){
                            setState(() {
                              _optionList.removeWhere((element) => element.flavor == _optionList[index].flavor);
                            });
                          },
                        ),
                    );
                  }
              ),
              showNewOptionCard ? AddOptionCard(
                onSave: onSave,
              ) : Container(),

              ColorButton(onPressed: (){
                setState(() {
                  showNewOptionCard = !showNewOptionCard;
                });
              }, label: Text(showNewOptionCard ? 'Hide' : 'Add New Option')),
            ],
          ),
        ),
      ),
    );
  }}

