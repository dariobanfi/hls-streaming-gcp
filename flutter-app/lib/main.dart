import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

// TODO change me
const videoSource = "";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HLS Streaming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter HLS Streaming Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter HLS player"),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          videoSource,
          betterPlayerConfiguration: const BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }
}
