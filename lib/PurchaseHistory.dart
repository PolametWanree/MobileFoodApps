import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatefulWidget {
  final String userEmail;

  PurchaseHistoryPage({required this.userEmail});

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการสั่งอาหาร'),
        backgroundColor: Colors.amber,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('orders')
            .where('userEmail', isEqualTo: widget.userEmail)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display a loading indicator.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No purchase history found.');
          } else {
            // Process and display the purchase history data.
            return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    Map<String, dynamic> orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
    var orderNumber = index + 1; // Order number starts from 1

    // Extract order details
    var items = orderData['items'] as List<dynamic>; // Assuming 'items' is not null
    var total = orderData['total'] as double; // Assuming 'total' is not null
    var status = orderData['status'] as String; // Fetch the 'status' field

    // Define text color based on status
    Color statusColor = status == 'ordered' ? Colors.red : status == 'delivered' ? Colors.green : Colors.black;

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Order #$orderNumber'),
          ),
          for (var item in items)
            ListTile(
              title: Text(item['name'] as String),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${item['price'].toStringAsFixed(2)}'),
                  Text('Quantity: ${item['quantity']}'),
                ],
              ),
            ),
          ListTile(
            title: Text('Total: \$${total.toStringAsFixed(2)}'),
          ),
          ListTile(
            title: Text('Status: $status', style: TextStyle(color: statusColor)),
          ),
        ],
      ),
    );
  },
);

          }
        },
      ),
    );
  }
}
