import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class DatabaseHelper {
  // Define the Firestore collection reference
  final CollectionReference collection =
      FirebaseFirestore.instance.collection(Product.collectionName);

  // Insert a product
  Future<DocumentReference> insertProduct(Product product) async {
    final docRef = await collection.add(product.toJson());
    return docRef;
  }

  // Update a product
  Future<void> updateProduct(Product product) async {
    await collection.doc(product.referenceId).update(product.toJson());
  }

  // Delete a product
  Future<void> deleteProduct(Product product) async {
    await collection.doc(product.referenceId).delete();
  }

  // Get all products as a stream
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  // Search for products by name
  Future<QuerySnapshot> searchProduct(String keyValue) {
    return collection.where(Product.colName, isEqualTo: keyValue).get();
  }
}



class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Define a method to fetch order details for a specific user
Future<List<OrderDetail>> getOrderDetails(String userEmail) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    final List<OrderDetail> orderDetails = [];

    for (final QueryDocumentSnapshot<Map<String, dynamic>> document in snapshot.docs) {
      final data = document.data();
      if (data != null && data['items'] != null) {
        final List<dynamic> items = data['items'];
        items.forEach((item) {
          final orderDetail = OrderDetail.fromMap(item);
          orderDetails.add(orderDetail);
        });
      }
    }

    return orderDetails;
  } catch (e) {
    // Handle any potential errors here
    print('Error fetching order details: $e');
    return []; // Return an empty list in case of an error
  }
}
}





Future<List<Product>> fetchProductDetails(List<OrderDetail> orderDetails) async {
  try {
    final productNames = orderDetails.map((orderDetail) => orderDetail.productName).toList();
    final productDetails = <Product>[];

    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: productNames)
        .get();

    snapshot.docs.forEach((productDocument) {
      final productData = productDocument.data();
      final product = Product(
        name: productDocument.id,
        description: productData['description'] ?? '', // Use the null-aware operator ?? to provide a default value
        price: (productData['price'] as num?)?.toDouble() ?? 0.0, // Use ?. to safely access and convert the value to double, and provide a default value if it's null
        quantity: productData['quantity'] ?? 0,
        favorite: productData['favorite'] ?? 0,
      );

      // Find the corresponding order detail and update it with the orderId and quantity
      final orderDetail = orderDetails.firstWhere(
        (detail) => detail.productName == product.name,
        orElse: () => OrderDetail(
          orderId: '', // Set orderId to empty for now, you'll need to update this with the actual orderId logic
          productName: product.name,
          pricePerUnit: product.price,
          quantity: 0, 
          status: 'ordered', 
        ),
      );
      
      // Update the orderId and quantity
      orderDetail.orderId = 'your_order_id'; // Replace with your actual orderId logic
      orderDetail.quantity = 1; // Set the quantity to 1 for now, update it with the actual quantity
      
      productDetails.add(product);
    });

    return productDetails;
  } catch (e) {
    print('Error fetching product details: $e');
    return [];
  }
}





