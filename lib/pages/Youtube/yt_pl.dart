import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeTubePage extends StatefulWidget {
  @override
  _HomeTubePageState createState() => _HomeTubePageState();
}

class _HomeTubePageState extends State<HomeTubePage> {
  TextEditingController _addItemController = TextEditingController();
  late YoutubePlayerController _youtubePlayerController;
  late DocumentReference linkRef;
  List<String> videoID = [];
  bool showItem = false;
  final utube = RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Youtube Player'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: _addItemController,
              onEditingComplete: () {
                if (utube.hasMatch(_addItemController.text)) {
                  _addItemFunction();
                } else {
                  _showSnackBar('Invalid Link', 'Please provide a valid link');
                }
              },
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Your Video URL',
                suffixIcon: GestureDetector(
                  child: Icon(Icons.add, size: 32),
                  onTap: () {
                    if (utube.hasMatch(_addItemController.text)) {
                      _addItemFunction();
                    } else {
                      _showSnackBar('Invalid Link', 'Please provide a valid link');
                    }
                  },
                ),
              ),
            ),
          ),
          Flexible(
  child: Container(
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: ListView.builder(
      itemCount: videoID.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.all(8),
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoID[index], // Use videoID directly
            flags: YoutubePlayerFlags(
              autoPlay: false,
            ),
          ),
          showVideoProgressIndicator: false,
          progressIndicatorColor: Colors.blue,
          progressColors: ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
        ),
      ),
    ),
  ),
),
        ],
      ),
    );
  }

   @override
  void initState() {
    super.initState();
    linkRef = FirebaseFirestore.instance.collection('links').doc('urls');
    _loadData(); // Moved the asynchronous operation to a separate method
  }

  Future<void> _loadData() async {
    await getData();
    print(videoID);
  }



void _addItemFunction() async {
  final videoUrl = _addItemController.text?.trim();

  if (videoUrl != null && utube.hasMatch(videoUrl)) {
    final videoId = extractVideoIdFromUrl(videoUrl);

    if (videoId != null) {
      await linkRef.set({
        videoId: videoUrl,
      }, SetOptions(merge: true));

      setState(() {
        videoID.add(videoId);
      });
    } else {
      _showSnackBar('Invalid Link', 'Please provide a valid YouTube video link');
    }
  } else {
    _showSnackBar('Invalid Link', 'Please provide a valid link');
  }

  FocusScope.of(context).unfocus();
  _addItemController.clear();
}

String? extractVideoIdFromUrl(String url) {
  try {
    final uri = Uri.parse(url);
    if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      return uri.queryParameters['v'];
    } else if (uri.host == 'youtu.be') {
      return uri.pathSegments.first;
    }
  } catch (e) {
    return null;
  }
  return null;
}






  getData() async {
  final documentSnapshot = await linkRef.get();
  if (documentSnapshot.exists) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    if (data != null) {
      final newVideoIDs = data.values.cast<String>().toList();
      videoID.clear();
      videoID.addAll(newVideoIDs);
      setState(() {
        videoID.shuffle();
        showItem = true;
      });
    }
  }
}


void _showSnackBar(String title, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}


}
