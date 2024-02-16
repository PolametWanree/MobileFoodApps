import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCustomerCheck extends StatefulWidget {
  @override
  _AdminCustomerCheckState createState() => _AdminCustomerCheckState();
}

class _AdminCustomerCheckState extends State<AdminCustomerCheck> {
  Future<void> _refreshData() async {
    // Fetch data or update data here.
    // For example, you can fetch the orders data again from Firestore.
  }

  void updateOrderStatus(DocumentReference orderRef) {
    // Update the status of the order to "delivered" in Firestore.
    orderRef.update({'status': 'delivered'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Customer Check'),
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No orders found.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var orderDocument = snapshot.data!.docs[index];
                  var orderData = orderDocument.data() as Map<String, dynamic>?;

                  if (orderData == null) {
                    return Container(); // Skip if orderData is null.
                  }

                  var orderNumber = index + 1; // Order number starts from 1

                  var items = orderData['items'] as List<dynamic>?; // Nullable
                  double? total = orderData['total'] as double?; // Nullable
                  String? userEmail = orderData['userEmail'] as String?;
                  String? status = orderData['status'] as String?;

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Order #$orderNumber'),
                          subtitle: Text('User Email: $userEmail'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderDocument.id)
                                  .delete();
                            },
                          ),
                        ),
                        if (items != null)
                          for (var item in items)
                            ListTile(
                              title: Text(item['name'] as String? ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Price: \$${item['price']?.toStringAsFixed(2) ?? ''}'),
                                  Text('Quantity: ${item['quantity'] ?? ''}'),
                                ],
                              ),
                            ),
                        ListTile(
  title: Text('Total: \$${total?.toStringAsFixed(2) ?? ''}'),
  subtitle: Row(
    children: [
      Text('Status: '),
      Text(
        '$status',
        style: TextStyle(
          color: status == 'ordered' ? Colors.red : status == 'delivered' ? Colors.green : Colors.black, // Define colors based on status
          fontWeight: FontWeight.bold, // Make the text bold
        ),
      ),
      if (status != 'delivered') // Display button only if status is not delivered
        Padding(
          padding: EdgeInsets.only(left: 16.0), // Add left padding
          child: ElevatedButton(
            onPressed: () {
              // Update the status to "delivered" and turn it green
              updateOrderStatus(orderDocument.reference);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            child: Text('Mark as Delivered'),
          ),
        ),
    ],
  ),
),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
