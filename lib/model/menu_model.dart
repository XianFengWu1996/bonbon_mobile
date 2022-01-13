
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/main.dart';
import 'package:bonbon_mobile/model/dio_config.dart';
import 'package:bonbon_mobile/model/error_model.dart';
import 'package:bonbon_mobile/model/request_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MenuModel extends ChangeNotifier {
  final List<MenuItem> _menuList = [];
  final List<UnitOption> _addOption = [];
  final List<UnitOption> _removeOption = [];
  final List<UnitOption> _updateOption = [];

  List<MenuItem> get menuList => _menuList;
  List<UnitOption> get addOption =>  _addOption;
  List<UnitOption> get removeOption =>  _removeOption;
  List<UnitOption> get updateOption =>  _updateOption;

  String token = '';

  getMenuList() async {
    try{
      _menuList.clear();
      Response menuResponse = await dioWithToken(token).get(menuUrl);

      if(menuResponse.data['menu'] != null){
        for (var item in menuResponse.data['menu']) {
          _menuList.add(MenuItem().toObject(item));
        }
      }
    } catch(e){
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  // UNIT OPTIONS
  addToRemoveOption(UnitOption options){
    _removeOption.add(options);
    showErrorToast('Unit add to delete list');
    notifyListeners();
  }

  undoRemoveOrUpdateOption(UnitOption option){
    _removeOption.removeWhere((element) => element.id == option.id);
    _updateOption.removeWhere((element) => element.id == option.id);
    showErrorToast('Unit delete undo');
    notifyListeners();
  }

  addToUpdateOption(UnitOption option){
    for (var element in _removeOption) {
      if(element.id == option.id){
        throw CustomException(message: 'Invalid Operation: (will be deleted)');
      }
    }
    _updateOption.add(option);

    notifyListeners();
  }

  addToAddOption(UnitOption options){
    _addOption.add(options);
    showSuccessToast('Unit add to add list');
    notifyListeners();
  }

  removeFromAddOption(UnitOption option){
    _addOption.removeWhere((element) => element.id == option.id);
    showToast('Unit remove from add list');
    notifyListeners();
  }


  // DATABASE FOR OPTION
  addOptionToDB(MenuItem menuItem, String flavor, List unitOptionList,Function onComplete) async {
    try{
      Response response = await dioWithToken(token).post(
        '$menuUrl/${menuItem.id}/option',
        data: {
          'flavor': flavor,
          'unitOptionList': unitOptionList,
        },
      );
      // if the request is successful, update the data locally to reflect the change
      menuItem.options.insert(0,MenuItemOptions().toObject(response.data['option']));
      onComplete();
      showSuccessToast('New Item added');
    } catch (e){
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  updateOptionInDB(MenuItem menuItem, String optionId, String flavor, Function done) async {
    List<Map<String, dynamic>> tempRemove = [];
    List<Map<String, dynamic>>  tempAdd = [];
    List<Map<String, dynamic>>  tempUpdate = [];

    // transform all the data from object to map
    for (var element in _removeOption) {
      tempRemove.add(element.toMap());
    }

    for (var element in _addOption) {
      tempAdd.add(element.toMap());
    }

    for (var element in _updateOption) {
      tempUpdate.add(element.toMap());
    }

    try {
      // http request to update the option
      Response response = await dioWithToken(token).patch(
        '$menuUrl/${menuItem.id}/option/$optionId',
        data: {
          'flavor': flavor,
          'removeOption': tempRemove,
          'addOption': tempAdd,
          'updateOption': tempUpdate,
        },
      );

      // once success, update the local data to reflect the change
      if(response.data['option'] != null){
        int menuItemIndex = _menuList.indexWhere((element) => element.id == menuItem.id);
        int optionIndex = _menuList[menuItemIndex].options.indexWhere((element) => element.id == response.data['option']['_id']);

        _menuList[menuItemIndex].options[optionIndex] = MenuItemOptions().toObject(response.data['option']);
      }

      resetOptionLists();
      done();
    } catch(e){
      showErrorToast(e.toString());
    }

    notifyListeners();
  }

  deleteOptionFromDB(MenuItem menuItem, String optionId) async {
    try{
      // http request to update the option
      await dioWithToken(token).delete(
        '$menuUrl/${menuItem.id}/option/$optionId',
      );
      menuItem.options.removeWhere((element) => element.id == optionId);
    } catch(e){
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  // DATABASE FOR MENU ITEM
  updateMenuItemName(MenuItem menuItem, String name) async {
    try{
      if(name.isEmpty){
        throw CustomException(message: 'Name can not be empty');
      }

      await dioWithToken(token).patch(
        '$menuUrl/${menuItem.id}/name?data=$name',
      );
      menuItem.name = name;
    } on CustomException catch(e){
      showErrorToast(e.message);
    } catch(e){
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  deleteMenuItem(MenuItem menuItem) async {
    try {
      await dioWithToken(token).delete('$menuUrl/${menuItem.id}');
      _menuList.removeWhere((element) => element.id == menuItem.id);
      showSuccessToast('Successfully delete item');
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/receipt/menu/edit', (route) => false);
    } catch(e){
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  addMenuItem(String menuName, List<MenuItemOptions> options) async {
    try {
      List temp = [];
      for (var element in options) {
        temp.add(element.toMap());
      }

      if(menuName.isEmpty){
        throw CustomException(message: 'Name cannot be empty');
      }

      if(options.isEmpty){
        throw CustomException(message: 'Require at least one option');
      }

      Response response = await dioWithToken(token).post(
        menuUrl,
        data: {
          'name': menuName,
          'options':temp
        },
      );
      
      _menuList.insert(0, MenuItem().toObject(response.data['option']));
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/receipt/menu/edit', (route) => false);
    } on CustomException catch(e) {
      showErrorToast(e.message);
    } catch(e){
      showErrorToast(e.toString());
    }
    notifyListeners();

  }

  resetOptionLists(){
    _removeOption.clear();
    _addOption.clear();
    _updateOption.clear();

    notifyListeners();
  }
}

class MenuItem {
  String name;  // name of the item
  List<MenuItemOptions> options; // options of the item
  String id;

  MenuItem({
    this.name = '',
    this.options = const [],
    this.id = '',
  });

  toObject(Map map){
    List<MenuItemOptions> _optionsList = [];

    for(var option in map['options']){
      _optionsList.add(MenuItemOptions().toObject(option));
    }

    return MenuItem(
      name: map['name'],
      options: _optionsList,
      id: map['_id'],
    );
  }
}

class MenuItemOptions {
  List<UnitOption> unitOption;
  String flavor;
  String id;

  MenuItemOptions({
    this.unitOption = const [],
    this.flavor = '',
    this.id = '',
  });

  toObject(Map map) {
    List<UnitOption> _list = [];
    map['unitOption'].forEach((el) {
      _list.add(UnitOption().toObject(el));
    });

    return MenuItemOptions(
      flavor: map['flavor'],
      unitOption: _list,
      id: map['_id'],
    );
  }

  Map toMap(){
    List<Map<String, dynamic>> _temp = [];
    for (var element in unitOption) {
      _temp.add(element.toMap());
    }
    return {
      'id': id,
      'flavor': flavor,
      'unitOption':_temp,
    };
  }
}

class UnitOption {
  String id;
  String unit;
  double price;

  UnitOption({
    this.id = '',
    this.unit = '',
    this.price = 0,
  });

  toObject(Map map){
    return UnitOption(
        id: map['_id'],
        unit: map['unit'].toString(),
        price: map['price'].toDouble()
    );
  }

  Map<String, dynamic> toMap(){
    return {
      '_id': id,
      'unit':unit,
      'price': price,
    };
  }
}