import 'package:flutter/material.dart';
import 'package:pj/OrderHistoryPage.dart';
import '../database/model.dart';
import 'package:pj/pages/product_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pj/main.dart';


class ShoppingCartPage extends StatefulWidget {
  final List<Product> selectedItems;
  final String userEmail;
  final double total; // Accept the total as a parameter
  final VoidCallback resetCart;

  ShoppingCartPage({
    required this.selectedItems,
    required this.userEmail,
    required this.total, // Accept the total as a parameter
    required this.resetCart,
  });

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

/// จำนวน
List<Product> groupItemsByProduct(List<Product> selectedItems) {
  Map<String, Product> groupedItems = {};

  for (var item in selectedItems) {
    if (groupedItems.containsKey(item.name)) {
      // If the product already exists in the map, increase the quantity
      groupedItems[item.name]!.quantity++;
    } else {
      // If it's a new product, add it to the map
      groupedItems[item.name] = item;
      groupedItems[item.name]!.quantity = 1;
    }
  }

  return groupedItems.values.toList();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  double total = 0;
  bool showReceipt = false;
  double calculateTotal(List<Product> groupedItems) {
  return groupedItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

  void updateTotal(List<Product> groupedItems) {
    total = calculateTotal(groupedItems);
  }



Future<void> sendToFirestore(String userEmail, List<Product> selectedItems, double total) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a new Firestore document for the order
  final CollectionReference orders = firestore.collection('orders');
  final List<Map<String, dynamic>> orderItems = selectedItems.map((item) {
    return {
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
    };
  }).toList();

  final Map<String, dynamic> orderData = {
    'userEmail': userEmail,
    'items': orderItems,
    'total': total,
    'timestamp': FieldValue.serverTimestamp(),
    'status': 'ordered', // Set the status to "ordered" by default
  };

  await orders.add(orderData);
}

void toggleReceiptVisibility() {
    setState(() {
      showReceipt = !showReceipt;
    });
  }



  @override
Widget build(BuildContext context) {
  List<Product> groupedItems = groupItemsByProduct(widget.selectedItems);
  double total = calculateTotal(groupedItems);
    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบรายการอาหาร'),
        backgroundColor: Colors.amber,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        ),
      ),
      body: StatefulBuilder(
  builder: (BuildContext context, StateSetter setState) {
    return ListView.builder(
  itemCount: groupedItems.length,
  itemBuilder: (context, index) {
    final product = groupedItems[index];
    return ListTile(
      title: Text(product.name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ราคา: \ ${product.price.toStringAsFixed(0)} บาท'),
          Row(
  children: [
    IconButton(
      icon: Icon(Icons.remove),
      onPressed: () {
        setState(() {
          if (product.quantity > 1) {
            product.quantity--;
            total = calculateTotal(groupedItems); // Update the total
          }
        });
      },
    ),
    Text('${product.quantity}'),
    IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        setState(() {
          product.quantity++;
          total = calculateTotal(groupedItems); // Update the total
        });
      },
    ),
  ],
      ),

            ],
          ),
        );
      },
    );
    },
  ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.amber,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ข้อมูลผู้ใช้',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'User Email: ${widget.userEmail}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final userEmail = user.email ?? '';
                    final total = calculateTotal(widget.selectedItems);

                    // Call the function to send data to Firebase Firestore
                    await sendToFirestore(userEmail, widget.selectedItems, total);

                    // Create order details
                    final List<OrderDetail> details = widget.selectedItems.map((item) {
                  return OrderDetail(
                    orderId: 'order_id', // Replace with your order ID logic
                    productName: item.name,
                    pricePerUnit: item.price,
                    quantity: 1, // Assuming quantity is always 1 for this example
                    status: 'ordered', // Set the status to "ordered" by default
                  );
                }).toList();

                    // You can also show a confirmation dialog or navigate to a confirmation page.
                    // For now, we'll just print a message.
                    print('Order placed successfully!');
                    // Clear the cart

                    // Navigate to OrderHistoryPage and pass user's email and total
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderHistoryPage(
                            selectedItems: widget.selectedItems,
                            userEmail: userEmail,
                            total: total, // Pass the total
                          ),
                        ),
                      );
                  } else {
                    // Handle the case where the user is not authenticated.
                    print('User is not authenticated.');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 238, 202, 72)),
                ),
                child: Text('สั่งออเดอร์'),
              ),
            ElevatedButton(
              onPressed: () {
                widget.resetCart(); // Call the resetCart function
                Navigator.pop(context);
              },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 238, 202, 72)),
                ),
              child: Text('ยกเลิกออเดอร์'),
            ),
          ],
        ),
      ),
    );
  }
  
}