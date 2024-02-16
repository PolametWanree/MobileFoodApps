import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {

  String name;
  double price;
  String description;
  double quantity; // Add the quantity parameter
  int favorite;
  String? referenceId;


  static const collectionName = 'products';
  static const colName = 'name';
  static const colDescription = 'description';
  static const colPrice = 'price';
  static const colQuantity = 'quantity'; // Add a constant for the quantity column
  static const colFavorite = 'favorite';

  Product({

    required this.name,
    required this.description,
    required this.price,
    required this.quantity , // Include quantity in the constructor
    required this.favorite,
    this.referenceId,
  });

  // Rest of your class code...
  Map<String, dynamic> toMap() {
  var mapData = <String, dynamic>{

    colName: name,
    colDescription: description,
    colPrice: price,
    colQuantity: quantity, // Include quantity in the map
    colFavorite: favorite,
  };
  return mapData;
}

Map<String, dynamic> toJson() {
  var jsonData = <String, dynamic>{

    colName: name,
    colDescription: description,
    colPrice: price,
    colQuantity: quantity, // Include quantity in the JSON
    colFavorite: favorite,
  };
  return jsonData;
}

}

class OrderData {
  final String orderId;
  final String userEmail;
  final double total;

  OrderData({
    required this.orderId,
    required this.userEmail,
    required this.total,
  });
}

class OrderDetail {
  String orderId;
  String productName;
  double pricePerUnit;
  int quantity;
  String status;

  OrderDetail({
    required this.orderId,
    required this.productName,
    required this.pricePerUnit,
    required this.quantity,
    required this.status,
  });

  // Rename the setters to avoid conflicts with instance variables
  setOrderId(String value) {
    orderId = value;
  }

  setQuantity(int value) {
    quantity = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productName': productName,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'status' : status,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      orderId: map['orderId'] ?? '',
      productName: map['productName'] ?? '',
      pricePerUnit: (map['pricePerUnit'] as num).toDouble(),
      quantity: map['quantity'] ?? 0,
      status: map['status'] ?? '',
    );
  }
}





