
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/main.dart';
import 'package:bonbon_mobile/model/dio_config.dart';
import 'package:bonbon_mobile/model/error_model.dart';
import 'package:bonbon_mobile/model/request_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MerchantItem{
  final String name;
  final String unit;
  num quantity;
  final num unitPrice;
  num totalPrice;

  MerchantItem({
    this.name = '',
    this.unit = '',
    this.quantity = 0,
    this.unitPrice = 0,
    this.totalPrice = 0,
  });

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  MerchantItem toObject(Map map){
    return MerchantItem(
        name: map['name'],
        unit: map['unit'],
        quantity: map['quantity'],
        unitPrice: map['unitPrice'],
        totalPrice: map['totalPrice'],
    );
  }
}

class Receipt {
  String? id;
  String receiptName;
  String customerName;
  String customerPhone;
  String pickupDate;
  String address;
  double deliveryFee;

  double total;
  int merchantCartQuantity;
  List<MerchantItem> merchants;
  String createdAt;


  Receipt({
    this.id = '',
    this.receiptName = '',
    this.customerName = '',
    this.customerPhone = '',
    this.pickupDate = '',
    this.total = 0,
    this.merchantCartQuantity = 0,
    this.merchants = const [],
    this.createdAt = '',
    this.address = '',
    this.deliveryFee = 0,
  });

  Map<String, dynamic> toMap(){
    var merchantList = [];
    for (var element in merchants) {
      merchantList.add(element.toMap());
    }

    return {
      'receiptName': receiptName,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'pickupDate' : pickupDate,
      'deliveryFee': deliveryFee,
      'address': address,
      'total': total,
      'merchantCartQuantity': merchantCartQuantity,
      'merchants': merchantList,
      'createdAt': createdAt
    };
  }

  Receipt toObject (Map map){
    List<MerchantItem> _merchantItems = [];
    map['merchants'].forEach((element){
      _merchantItems.add(MerchantItem().toObject(element));
    });

    return Receipt(
        id: map['_id'],
        receiptName: map['receiptName'],
        customerName: map['customerName'],
        address: map['address'] ?? '',
        deliveryFee: map['deliveryFee'].toDouble() ?? 0.00,
        customerPhone: map['customerPhone'],
        pickupDate: map['pickupDate'],
        total: map['total'].toDouble(),
        merchantCartQuantity: map['merchantCartQuantity'].toInt(),
        merchants: _merchantItems,
        createdAt: map['createdAt'],
    );
  }

}

class ReceiptModel extends ChangeNotifier {
  // RECEIPT
  String token = '';
  String _id = '';
  String _receiptName = '';
  final List<Receipt> _receipts = [];
  Receipt _originalReceipt = Receipt();

  final List<MerchantItem> _merchants = [];
  double _total = 0;
  int _merchantCartQuantity = 0;

  String _customerName = '';
  String _customerPhone = '';
  String _pickupDate = '';

  String _address = '';
  double _deliveryFee = 0;


  String get id => _id;
  List<MerchantItem> get merchantCart => _merchants;
  double get total => _total;
  int get cartQuantity  => _merchantCartQuantity;
  String get customerName => _customerName;
  String get customerPhone => _customerPhone;
  String get pickupDate => _pickupDate;
  List<Receipt> get receipts => _receipts;
  String get receiptName => _receiptName;

  String get address => _address;
  double get deliveryFee => _deliveryFee;

  // MERCHANT ITEM RELATED
  // add to the merchant item
  void addMerchantItem(MerchantItem item){
    for (var element in _merchants) {
      if(element.name == item.name){
        element.quantity += item.quantity;
        element.totalPrice += item.totalPrice;
        updateTotalAndQuantity();
        notifyListeners();
        return;
      }
    }

    _merchants.add(item);
    updateTotalAndQuantity();

    notifyListeners();
  }

  // update the existing merchant item
  void updateMerchantItem(MerchantItem item, num newCount){
    for (var element in _merchants) {
      if (element.name == item.name) {
        element.quantity = newCount;
        element.totalPrice = newCount * element.unitPrice;
      }
    }
    updateTotalAndQuantity();
    notifyListeners();

  }

  // delete a merchant item from the list
  void deleteMerchantItem(MerchantItem item){
    _merchants.removeWhere((element) => element.name == item.name);
    updateTotalAndQuantity();

    notifyListeners();
  }

  void updateTotalAndQuantity(){
    _total = 0;
    _merchantCartQuantity = 0;
    for(MerchantItem merchantItem in _merchants){
      _total += merchantItem.totalPrice;
      _merchantCartQuantity += merchantItem.quantity as int;
    }
  }

  // reset the model but not the lists
  clearMerchantItemData(){
    _id = '';
    _total = 0;
    _merchantCartQuantity = 0;
    _customerName = '';
    _customerPhone = '';
    _pickupDate = '';
    _deliveryFee = 0;
    _address = '';
    _receiptName = '';
    _originalReceipt = Receipt();
    _merchants.clear();

    notifyListeners();
  }

  // getting the customer information
  void saveCustomerInfo({required String type, required data}){
    switch(type){
      case 'name':
        _customerName = data;
        break;
      case 'phone':
        _customerPhone = data;
        break;
      case 'date':
        _pickupDate = data;
        break;
      case 'receipt_name':
        _receiptName = data;
        break;
      default:
        break;
    }

    notifyListeners();
  }

  void saveDeliveryInfo(String address, double fee){
    if(address.isEmpty){
      showErrorToast('Address is empty');
      return;
    }

    _address = address;
    _deliveryFee = fee;

    notifyListeners();
  }

  void removeDelivery(){
    _address = '';
    _deliveryFee = 0;
    notifyListeners();
  }

  // RECEIPT RELATED
  // handle adding and updating receipt
  generateReceipt() async {
    try{
      if(_receiptName.isEmpty){
        throw CustomException(message: 'Receipt name should not be empty');
      }

      if(_customerName.isEmpty || _customerPhone.isEmpty){
        throw CustomException(message: 'Customer information should not be blank');
      }

      if(_pickupDate.isEmpty){
        throw CustomException(message: 'Pick up date should not be empty');
      }

      if(_merchants.isEmpty){
        throw CustomException(message: 'Add some items to proceed');
      }

      Receipt _tempReceipt = Receipt(
        id: _id,
        receiptName: _receiptName,
        customerName: _customerName,
        customerPhone: _customerPhone,
        address: _address,
        deliveryFee: deliveryFee,
        pickupDate: _pickupDate,
        total: _total,
        merchantCartQuantity: _merchantCartQuantity,
        merchants: _merchants,
      );

      if(_id.isEmpty){
        Response response = await dioWithToken(token).post(
          receiptUrl,
          data: {
            'receipt': _tempReceipt.toMap()
          },
        );

        _receipts.insert(0, Receipt().toObject(response.data['receipt']));
        showSuccessToast('New Receipt Created');
      } else {
        Response response = await dioWithToken(token).patch(
          '$receiptUrl/$_id',
          data: {
            'receipt': _tempReceipt.toMap()
          },
        );
        var index = _receipts.indexWhere((element) => element.id == response.data['receipt']['_id']);
        _receipts[index] = Receipt().toObject(response.data['receipt']);

        showUpdateToast('Receipt updated');
      }
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/receipt/home', (route) => false);
    } on CustomException catch(e){
      showErrorToast(e.message);
    } catch (e){
      showErrorToast('An unexpected error has occur ${e.toString()}');
    }
    notifyListeners();
  }

  // retrieve the list of receipt before page loaded
  retrieveReceiptList () async {
    try{
      _receipts.clear();

      Response response = await dioWithToken(token).get(receiptUrl);

      if(response.data != null){
        response.data['receipts'].forEach((element) => {
          _receipts.add(Receipt().toObject(element))
        });
      }
      
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/receipt/home', (route) => false);
    } catch(e){
      showErrorToast(e.toString());
    }
  }

  // pass in the data to generate a new receipt model
  generateReceiptModel(Receipt receipt){
    clearMerchantItemData();

    _originalReceipt = Receipt().toObject(receipt.toMap());
    _id = receipt.id!;
    _receiptName = receipt.receiptName;
    _customerName = receipt.customerName;
    _customerPhone = receipt.customerPhone;
    _pickupDate = receipt.pickupDate;
    _address = receipt.address;
    _deliveryFee = receipt.deliveryFee;
    _total = receipt.total;
    _merchantCartQuantity = receipt.merchantCartQuantity;
    for (var element in receipt.merchants) {
      _merchants.add(
        MerchantItem().toObject(element.toMap())
      );
    }

    notifyListeners();
  }

  // delete the receipt from database and the model
  deleteReceipt(Receipt receipt) async {
    try {
      await dioWithToken(token).delete('$receiptUrl/${receipt.id}',);
      _receipts.removeWhere((element) => element.id == receipt.id);
      showErrorToast('Receipt Deleted');
    } on CustomException catch(e){
      showErrorToast(e.message);
    } catch (e) {
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  resetReceipt(){
    for (var element in _receipts) {
      if(element.id == _originalReceipt.id){
        element = _originalReceipt;
        notifyListeners();
        return;
      }
    }

  }
}



