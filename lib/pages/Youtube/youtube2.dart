// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class YouTubePlayerPage extends StatefulWidget {
//   @override
//   _YouTubePlayerPageState createState() => _YouTubePlayerPageState();
// }

// class _YouTubePlayerPageState extends State<YouTubePlayerPage> {
//   TextEditingController _urlController = TextEditingController();
//   late YoutubePlayerController _playerController;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _playerController = YoutubePlayerController(
//       initialVideoId: 'YOUR_INITIAL_VIDEO_ID', // Replace with a default video ID
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _playerController.dispose();
//     super.dispose();
//   }

//   void _playVideo() {
//   final videoUrl = _urlController.text.trim();
//   final videoId = extractVideoIdFromUrl(videoUrl);

//   if (videoId != null) {
//     setState(() {
//       _playerController.load(videoId.toString());
//       _saveVideoToFirestore(videoId.toString(), videoUrl); // Convert videoId to a string here
//     });
//   }
// }


//   String extractVideoIdFromUrl(String url) {
//   try {
//     final uri = Uri.parse(url);
//     if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
//       return uri.queryParameters['v'] ?? 'defaultVideoId'; // Use a default if not found
//     } else if (uri.host == 'youtu.be') {
//       return uri.pathSegments.first ?? 'defaultVideoId'; // Use a default if not found
//     }
//   } catch (e) {
//     return 'defaultVideoId'; // Handle any exceptions by providing a default
//   }
//   return 'defaultVideoId'; // Handle other cases by providing a default
// }

//   void _saveVideoToFirestore(String videoId, String videoUrl) {
//     _firestore.collection('videos').doc(videoId).set({
//       'url': videoUrl,
//       // Add more data if needed
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YouTube Player and Firestore'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             YoutubePlayer(controller: _playerController),
//             TextField(
//               controller: _urlController,
//               decoration: InputDecoration(
//                 hintText: 'Enter YouTube URL',
//               ),
//             ),
//             ElevatedButton(
//   onPressed: _playVideo,
//   child: Text('Play Video'),
// ),
//           ],
//         ),
//       ),
//     );
//   }
// }
