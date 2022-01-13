import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:bonbon_mobile/components/Cards/option_card.dart';
import 'package:bonbon_mobile/components/Dialogs/delete_confirmation_dialog.dart';
import 'package:bonbon_mobile/components/Lists/scroll_list_view.dart';
import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/components/transparent_appbar.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:bonbon_mobile/components/Cards/add_option_card.dart';
import 'package:bonbon_mobile/receipt/menu/edit/edit_option_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditMenuItemPage extends StatefulWidget {
  final MenuItem menuItem;
  const EditMenuItemPage({Key? key, required this.menuItem}) : super(key: key);

  @override
  _EditMenuItemPageState createState() => _EditMenuItemPageState();
}

class _EditMenuItemPageState extends State<EditMenuItemPage> {
  bool showNewOptionCard = false;
  bool showInput = false;
  bool titleNeedsUpdate = false;

  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = widget.menuItem.name;
  }

  @override
  void dispose() {
    super.dispose();
    showNewOptionCard = false;
  }
  @override
  Widget build(BuildContext context) {
    MenuModel menuModel = Provider.of<MenuModel>(context);
    void onComplete(){
      setState(() {
        showNewOptionCard = false;
      });
    }

    void cardOnSave (startLoading, stopLoading, btnState, flavor, unitOptionList) async {
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

        List<Map<String, dynamic>> _temp = [];
        for (var element in unitOptionList) {
          _temp.add(element.toMap());
        }
        await menuModel.addOptionToDB(
            widget.menuItem,
            flavor,
            _temp,
            onComplete
        );

        stopLoading();
      }
    }

    void titleOnChanged(value){
      setState(() {
        titleNeedsUpdate = true;
      });
    }

    void titleOnSave(){
      if(titleNeedsUpdate){
        menuModel.updateMenuItemName(widget.menuItem, _name.text);
      }
      setState(() {
        showInput = false;
      });
    }

    void tapToEdit(){
      setState(() {
        showInput = true;
      });
    }

    void confirmDelete(index){
        if(widget.menuItem.options.length > 1){
          menuModel.deleteOptionFromDB(widget.menuItem, widget.menuItem.options[index].id);
          Navigator.pop(context);
          setState(() {});
        } else {
          showErrorToast('Menu with no item not allowed');
        }
    }

    return Scaffold(
      appBar: TransparentAppBar(
        onPressed: (){
          Navigator.pop(context);
        },
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Colors.grey,
            ),
            child: PopupMenuButton(
              color: Colors.grey[500],
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Remove",style: TextStyle(color: Colors.white),),
                ),
              ],
              onSelected: (item) {
                if(item == 0){
                  showDialog(context: context, builder: (context){
                    return DeleteConfirmationDialog(
                        textToConfirm: widget.menuItem.name,
                        onPressed: (){
                          menuModel.deleteMenuItem(widget.menuItem);
                        }
                    );
                  });
                }
             },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(showNewOptionCard ? FontAwesomeIcons.minus : FontAwesomeIcons.plus),
        onPressed: (){
          setState(() {
            showNewOptionCard = !showNewOptionCard;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showNewOptionCard ? AddOptionCard(
              onSave: cardOnSave,
            ) : Container(),
            MenuItemTitle(
                showInput: showInput,
                name: _name,
                onChanged: titleOnChanged,
                onSave: titleOnSave,
                tapToEdit: tapToEdit,
            ),
            MenuItemList(menuItem: widget.menuItem, onDelete: confirmDelete,),
          ],
        ),
      ),
    );
  }
}

class MenuItemTitle extends StatelessWidget {
  final bool showInput;
  final TextEditingController name;
  final void Function()? onSave;
  final void Function()? tapToEdit;
  final void Function(dynamic)? onChanged;

  const MenuItemTitle({
    Key? key,
    required this.showInput,
    required this.name,
    required this.onSave,
    required this.tapToEdit,
    required this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        showInput ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthInput(
                icon: FontAwesomeIcons.coffee,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                label: 'Menu Item',
                onChanged: onChanged,
                controller: name),
            ColorButton(onPressed: onSave, label: const Text('Save')),
          ],
        ):
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name.text, style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(width: 5,),
            IconButton(
                onPressed: tapToEdit,
                icon: const Icon(FontAwesomeIcons.pencilAlt, size: 18,)),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MenuItemList extends StatelessWidget {
  final MenuItem menuItem;
  final Function onDelete;
  const MenuItemList({
    Key? key,
    required this.menuItem,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollListView(
        length: menuItem.options.length,
        itemBuilder: (context, index){
          MenuItemOptions option = menuItem.options[index];
          return OptionCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return OptionsEditingPage(
                  option: option,
                  menuItem: menuItem,
                );
              }));
            },
            option: option,
            trailing: IconButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return DeleteConfirmationDialog(
                    textToConfirm: option.flavor,
                    onPressed: (){
                      onDelete(index);
                    });
              });
            }, icon: const Icon(FontAwesomeIcons.trash, color: Colors.red,)),
          );
        });
  }
}



