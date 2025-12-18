import 'package:mechine_test/models/cart_models.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String deliveryAddress;
  final String customerName;
  final String customerPhone;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.customerName,
    required this.customerPhone,
    required this.orderDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'totalAmount': totalAmount,
    'status': status,
    'deliveryAddress': deliveryAddress,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'orderDate': orderDate.toIso8601String(),
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    userId: json['userId'],
    items: (json['items'] as List)
        .map((item) => CartItem.fromJson(item))
        .toList(),
    totalAmount: (json['totalAmount'] as num).toDouble(),
    status: json['status'] ?? 'Pending',
    deliveryAddress: json['deliveryAddress'],
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    orderDate: DateTime.parse(json['orderDate']),
  );
}
