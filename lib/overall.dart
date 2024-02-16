import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pj/database/database_helper.dart';
import 'package:pj/pages/Youtube/youtube2.dart';
import 'package:pj/pages/Youtube/yt_pl.dart';
import 'package:pj/pages/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'pages/login.dart';
import 'package:pj/database/database_helper.dart';
import 'package:pj/pages/search.dart';
import 'package:pj/pages/login.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pj/AdminCustomer_check.dart'; // Import the AdminCustomerCheck page
import 'package:pj/pages/ReadFeedback.dart';

class Overall extends StatefulWidget {
  const Overall({super.key});

  @override
  State<Overall> createState() => _OverallState();
}

class _OverallState extends State<Overall> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping PG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        fontFamily: 'Kanit',
      ),
    );
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomepage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomepage> {
  final List<String> imagePaths = [
    'assets/images/BG1.jpg',
    'assets/images/t1.jpg',
    'assets/images/dog1.jpg',
    'assets/images/dog2.jpg',
    // Add more image paths as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text('Admin Store'),
        centerTitle: true,
        actions: [

          IconButton(
            icon: Icon(Icons.login), // Add the icon for login here
            onPressed: () {
              // Navigate to the login page when the icon is pressed
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginPage(), // Replace with the actual login page
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 70, left: 28.8, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Menu',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 65, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'คุณสามารถทำการเพื่มและการลบหรือดูสต็อกของที่เหลือในคลังได้หรือทำการตรวจสอบ Order ที่กำลังเข้ามาได้',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 18, // Adjust the font size as needed
                      ),
                    ),
                  ],
                ),
              ),
              
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9, // You can adjust the aspect ratio as needed
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                items: imagePaths.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 700, // Set the desired width for the image
                        height: 100, // Set the desired height for the image
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imagePath), // Adjust the image path as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

          Padding(
  padding: EdgeInsets.only(top: 70, left: 70, right: 70, bottom: 50),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {
          // Add your action here when the first CircleAvatar is pressed
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductScreen(dbHelper: DatabaseHelper()),
            ),
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30,
              child: Icon(
                Icons.edit_note, // Add your desired icon here
                color: Colors.white, // Customize the icon color
              ),
            ),
            SizedBox(height: 8), // Add some spacing between CircleAvatar and text
            Text(
              'Edit Menu', // Add your desired text here
              style: TextStyle(
                color: Colors.black, // Customize the text color
                fontSize: 16, // Customize the font size
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          // Add your action here when the second CircleAvatar is pressed
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdminCustomerCheck(), // Navigate to AdminCustomerCheck
            ),
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30,
              child: Icon(
                Icons.info, // Add your desired icon here
                color: Colors.white, // Customize the icon color
              ),
            ),
            SizedBox(height: 8), // Add some spacing between CircleAvatar and text
            Text(
              'Customer Check', // Add your desired text here
              style: TextStyle(
                color: Colors.black, // Customize the text color
                fontSize: 16, // Customize the font size
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          // Add your action here when the second CircleAvatar is pressed
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FeedbackDisplayPage(), // Navigate to AdminCustomerCheck
            ),
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30,
              child: Icon(
                Icons.mail_outline_rounded, // Add your desired icon here
                color: Colors.white, // Customize the icon color
              ),
            ),
            SizedBox(height: 8), // Add some spacing between CircleAvatar and text
            Text(
              'Feedback', // Add your desired text here
              style: TextStyle(
                color: Colors.black, // Customize the text color
                fontSize: 16, // Customize the font size
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)

            ],
          ),
        ),
      ).animate().fadeIn().scale().move(delay: 300.ms, duration: 300.ms),
    );
  }
}
