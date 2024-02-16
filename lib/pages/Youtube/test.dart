// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('YouTube Player Example'),
//           backgroundColor: Colors.white, // Change background color to white
//         ),
//         body: VideoPlayerScreen(),
//       ),
//     );
//   }
// }

// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late YoutubePlayerController _controller1;
//   late YoutubePlayerController _controller2;

//   @override
//   void initState() {
//     super.initState();

//     _controller1 = YoutubePlayerController(
//       initialVideoId: 'orKgpMHu4So',
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//       ),
//     );

//     _controller2 = YoutubePlayerController(
//       initialVideoId: '2HIkoxGVmOM',
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//       ),
//     );
//   }

//   void switchToFirstVideo() {
//     _controller2.pause();
//     _controller1.play();
//   }

//   void switchToSecondVideo() {
//     _controller1.pause();
//     _controller2.play();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         YoutubePlayer(
//           controller: _controller1,
//           showVideoProgressIndicator: true,
//         ),
//         ElevatedButton(
//           onPressed: switchToFirstVideo,
//           child: Text('Play First Video'),
//         ),
//         YoutubePlayer(
//           controller: _controller2,
//           showVideoProgressIndicator: true,
//         ),
//         ElevatedButton(
//           onPressed: switchToSecondVideo,
//           child: Text('Play Second Video'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller1.dispose();
//     _controller2.dispose();
//   }
// }
