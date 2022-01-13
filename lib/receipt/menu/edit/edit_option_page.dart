import 'package:bonbon_mobile/components/Cards/update_unit_card.dart';
import 'package:bonbon_mobile/components/Dialogs/unit_option_dialog.dart';
import 'package:bonbon_mobile/components/Lists/scroll_list_view.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/components/transparent_appbar.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:bonbon_mobile/receipt/menu/edit/edit_unit_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class OptionsEditingPage extends StatefulWidget {
  final MenuItemOptions option;
  final MenuItem menuItem;
  const OptionsEditingPage({Key? key, required this.option, required this.menuItem}) : super(key: key);

  @override
  State<OptionsEditingPage> createState() => _OptionsEditingPageState();
}

class _OptionsEditingPageState extends State<OptionsEditingPage> {
  final TextEditingController _flavor = TextEditingController();

  @override
  void initState() {
    super.initState();
    _flavor.text = widget.option.flavor;
  }

  @override
  Widget build(BuildContext context) {
    MenuModel menuModel = Provider.of<MenuModel>(context);

    void saveUnitOption(){
      if(_flavor.text == widget.option.flavor
          && menuModel.addOption.isEmpty
          && menuModel.removeOption.isEmpty
          && menuModel.updateOption.isEmpty
      ){
        Navigator.pushNamed(context, '/receipt/menu/edit');
      } else {
        menuModel.updateOptionInDB(
            widget.menuItem,
            widget.option.id,
            (_flavor.text == widget.option.flavor ? '' : _flavor.text),
                (){
              Navigator.pushNamed(context, '/receipt/menu/edit');
              showSuccessToast('Update success');
            }
        );
      }
    }

    void floatButtonOnPressed(){
      showDialog(context: context, builder: (context){
        return UnitOptionDialog(
          unitOptionList: widget.option.unitOption,
        );
      });
    }

    return Scaffold(
      appBar: TransparentAppBar(
        onPressed: (){
          menuModel.resetOptionLists();
          Navigator.pop(context);
        },
        actions: [TextButton(onPressed: saveUnitOption, child: const Text('SAVE'))],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.plus),
        onPressed: floatButtonOnPressed,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ADD LIST
            menuModel.addOption.isNotEmpty ? UnitOptionList(
              optionList: menuModel.addOption,
              title: 'ADD',
              color: Colors.green,
              onPressed: (option){
                menuModel.removeFromAddOption(option);
              },
            ) : Container(),

            // DELETE LIST
            menuModel.removeOption.isNotEmpty ? UnitOptionList(
              optionList: menuModel.removeOption,
              color: Colors.red,
              title: 'DELETE',
              onPressed: (option){
                menuModel.undoRemoveOrUpdateOption(option);
              },
            ) : Container(),
            AuthInput(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                icon: FontAwesomeIcons.coffee,
                label: 'Flavor',
                controller: _flavor
            ),
            ScrollListView(
                length: widget.option.unitOption.length,
                itemBuilder: (context, index){
                  UnitOption _unitOption = widget.option.unitOption[index];
                  UnitOption _updateOption = UnitOption();
                  bool toBeUpdated = false;

                  for (var element in menuModel.removeOption) {
                    if(element.id == _unitOption.id){
                      toBeUpdated = true;
                    }
                  }

                  for (var element in menuModel.updateOption) {
                    if(element.id == _unitOption.id){
                      toBeUpdated = true;
                      _updateOption = element;
                    }
                  }
                  return Column(
                    children: [
                      UpdateUnitCard(
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              return UnitOptionDialog(
                                unitOptionList: widget.option.unitOption,
                                unitOption: _unitOption,
                              );
                            });
                          },
                        toBeUpdate: toBeUpdated,
                        unit: _unitOption,
                        updateUnit: _updateOption,
                        toUndo: (){
                          setState(() {
                            _updateOption = UnitOption();
                          });
                          menuModel.undoRemoveOrUpdateOption(_unitOption);
                        },
                        toRemove: (){
                          menuModel.addToRemoveOption(widget.option.unitOption[index]);
                        },
                      ),
                    ],
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
