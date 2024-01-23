import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';

class RemoteDesktop extends StatefulWidget {
  const RemoteDesktop({super.key});

  @override
  State<RemoteDesktop> createState() => _RemoteDesktopState();
}

class _RemoteDesktopState extends State<RemoteDesktop> {
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('rd'),
        ),
        body: const Center(
          child: Text('xxxxxx'),
        ));
  }
}
