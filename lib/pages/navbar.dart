import 'package:flutter/material.dart';
import 'package:pj/pages/Youtube/youtube2.dart';
import 'package:pj/pages/Youtube/yt_pl.dart';
import 'package:pj/pages/feedback.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pj/pages/Youtube/yt_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pj/pages/Youtube/test.dart';

class NavBar extends StatefulWidget {
  NavBar({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late String userEmail = ''; // Initialize with an empty string

@override
void initState() {
  super.initState();
  fetchUserEmail(); // Fetch user's email when the widget is initialized
}

  Future<void> fetchUserEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await widget.firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            userEmail = userData['email'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final Uri _url = Uri.parse('https://www.facebook.com/');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
  accountName: const Text(''), // Empty placeholder for accountName
  accountEmail: Text(userEmail), // Display the user's email address
  currentAccountPicture: CircleAvatar(
    child: Icon(Icons.person),
  ),
),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Menu แนะนะประจำเดือน'),
            subtitle: Text(
                'เมนูพิเศษประจำฤดูกาล\n*มาเฉพาแต่ละเดือน*\n________\nเนื้อหมาชิบะ\nเนื้อหมาบ่อ 1\n________\nสูตรเด็ดเฮียตี๋'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Menu ยอดฮิต'),
            subtitle: Text('เนื้อหมาสามชั้น\nเนื้อวัวแองกุว\nเนื่อแมว'),
          ),
          ListTile(
            leading: Icon(Icons.link),
            title: Text('Visit Website'),
            onTap: () {
              _launchUrl();
            },
          ),
          ListTile(
            leading: Icon(Icons.youtube_searched_for),
            title: Text('Visit Clip Review'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeTubePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.email_rounded),
            title: Text('Feedback'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FeedbackPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

