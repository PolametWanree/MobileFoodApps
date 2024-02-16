import 'package:flutter/material.dart';
import 'package:pj/database/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student.dart'; // Import the StudentPage

class OrderHistoryPage extends StatefulWidget {
  final List<Product> selectedItems;
  final String? userEmail;
  final double total;

  OrderHistoryPage({
    required this.selectedItems,
    required this.userEmail,
    required this.total,
  });

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  get orderDetails => null;

  Future<void> sendToFirestore() async {
    // ... Your Firestore code here ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Accept'),
        backgroundColor: Colors.amber,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true, // Center-align the title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'รับออเดอร์ เรียบร้อย\nกรุณารอรับออเดอร์ที่โต๊ะของท่าน',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              FutureBuilder<List<OrderDetail>>(
                future: orderDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('');
                  } else {
                    final orderDetails = snapshot.data!;
                    return Column(
                      children: orderDetails.map((orderDetail) {
                        return ListTile(
                          title: Text(orderDetail.productName),
                          subtitle: Text(
                            'Price: \$${orderDetail.pricePerUnit.toStringAsFixed(2)} ',
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              Text(
  'ราคารวมทั้งหมด: \ ${calculateTotal(widget.selectedItems).toStringAsFixed(0)} ฿',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Student(), // Navigate to StudentPage
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.amber, // Change the button color to green
            ),
            child: Text('กลับสู่หน้าหลัก'),
          ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotal(List<Product> selectedItems) {
  double total = 0;
  for (var product in selectedItems) {
    total += (product.price * product.quantity);
  }
  return total;
}
}
