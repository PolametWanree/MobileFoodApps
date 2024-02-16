import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pj/OrderHistoryPage.dart';
// Import the OrderPlacePage
import 'package:pj/database/database_helper.dart';
import 'package:pj/database/model.dart';
import 'package:pj/pages/login.dart';
import 'package:pj/pages/product_user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pj/database/database_helper.dart';
import 'package:pj/pages/search.dart';
import 'package:pj/pages/navbar.dart';
import 'package:pj/database/database_helper.dart';
import 'package:pj/PurchaseHistory.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);
  
  @override
  State<Student> createState() => _StudentState();
}



class _StudentState extends State<Student> {
  List<Product> selectedItems = [];
  double total = 0.0; // Initialize total
  List<String> imagePaths = []; 
  final videoURL = '';
  
@override
void initState() {
  super.initState();
  loadImagesFromFirebase().then((urls) {
    setState(() {
      imagePaths = urls;
    });
  });
}

  Future<List<String>> loadImagesFromFirebase() async {
  final List<String> imageUrls = [];
  final FirebaseStorage storage = FirebaseStorage.instance;
  final List<String> imagePaths = [
    'images/o1.jpg',
    'images/o2.jpg',
    'images/o3.jpg',
    'images/o4.jpg',
        'images/o5.jpg',
            'images/o6.jpg',
                'images/o7.jpg',
                    'images/main2.jpg',
    // Add more image paths as needed
  ];

  for (String imagePath in imagePaths) {
  try {
    final Reference ref = storage.ref().child(imagePath);
    final String downloadURL = await ref.getDownloadURL();
    print('Downloaded URL: $downloadURL'); // Add this line for debugging
    imageUrls.add(downloadURL);
  } catch (e) {
    print('Error loading image: $e');
  }
}


  return imageUrls;
}


  
  String? userEmail = FirebaseAuth.instance.currentUser?.email ?? ''; // Provide a default value
 // Define userEmail here
   List<Product> productDetails = [];
  void addToSelectedItems(Product item) {
    setState(() {
      selectedItems.add(item);
      total += item.price; // Update total when an item is added
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(firestore: FirebaseFirestore.instance),
      appBar: AppBar(
        title: const Text('Menu & Order'),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
          onPressed: (){
            logout(context);
          },
          icon: const Icon(Icons.login_outlined)),
        ],
        backgroundColor: Colors.amber,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        ),
        ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70, left: 28.8, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu \nShabuMAMALA',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(),).moveY(begin: -20,end: 10,curve: Curves.easeInOut, duration: 1000.ms).then().moveY(begin: 5,end: -25,curve: Curves.easeInOut),
                  
                  Text(
                    'คุณสามารถสั่งอาหารหรือดูรายการอาหารผ่านหน้าต่างเหล่านี้ได้',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 18,
                    ),
                  ).animate().fadeIn().scale().move(delay: 300.ms, duration: 300.ms),

                ],
              ),
            ),
            CarouselSlider(
  options: CarouselOptions(
    aspectRatio: 16 / 9,
    enlargeCenterPage: true,
    autoPlay: true,
  ),
  items: imagePaths.map((imagePath) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: 700,
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imagePath), // Load image from URL
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }).toList(),
).animate().fadeIn().scale().move(delay: 300.ms, duration: 300.ms),

            
     Padding(
  padding: EdgeInsets.only(top: 70, bottom: 50, left: 70, right: 70),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () async {
          if (userEmail != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductUserScreen(
                  dbHelper: DatabaseHelper(),
                  userEmail: userEmail!,
                ),
              ),
            );
          } else {
            print('User is not authenticated.');
          }
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 30,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8), // Add some spacing between CircleAvatar and text
            Text(
              'Your Cart',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 13,
             
              ),
            ),
          ],
        ),
      ).animate().fadeIn().scale().move(delay: 300.ms, duration: 300.ms),
      GestureDetector(
        onTap: () async {
          if (userEmail != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PurchaseHistoryPage(userEmail: userEmail!),
                // Provide a default value for userEmail using '??'
              ),
            );
          } else {
            print('User is not authenticated.');
          }
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 30,
              child: Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8), // Add some spacing between CircleAvatar and text
            Text(
              'Purchase History',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 13,
              
              ),
            ),
          ],
        ),
      ).animate().fadeIn().scale().move(delay: 300.ms, duration: 300.ms),
    ],
  ),
),

          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MaterialApp(
    home: Student(),
  ));
}






