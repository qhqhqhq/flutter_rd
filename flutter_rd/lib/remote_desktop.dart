import 'dart:convert';

import 'package:flutter_rd/signalling_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';

class RemoteDesktop extends StatefulWidget {
  const RemoteDesktop({super.key});

  @override
  State<RemoteDesktop> createState() => _RemoteDesktopState();
}

class _RemoteDesktopState extends State<RemoteDesktop> {
  SignallingClient? sc;

  RTCPeerConnection? peerConnection;
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();
  final Map<String, dynamic> _iceConfig = {
      "iceServers": [
        {
          "urls": [
            "stun:stun.l.google.com:19302"
          ]
        },
      ],
      "iceTransportPolicy": "all"
  };

  @override
  void initState() {
    super.initState();

    var signallingClient = SignallingClient("ws://localhost:8081/ws", "rd");
    signallingClient.handleMessage =(String e) {
      var msg = jsonDecode(e);
      if (msg["type"] == "session ok") {
        print("session ok");
      } else if (msg["type"] == "sdp") {
        var sdp = msg["data"];
        _onSDP(sdp["type"], sdp["sdp"]);
      } else if (msg["type"] == "ice") {
        var ice = msg["data"];
        _onICE(ice["candidate"], ice["sdpMid"], ice["sdpMLineIndex"]);
      }
    };
    setState(() {
      sc = signallingClient;
    });
  }

  void _connect() async {
    await _localRenderer.initialize();

    if (peerConnection != null) return;
    var pc = await createPeerConnection(_iceConfig);
    pc.onIceCandidate = (RTCIceCandidate ice) {
      var iceMsg = {
        "type": "ice",
        "data": ice.toMap(),
      };
      sc?.send(jsonEncode(iceMsg));
    };
    pc.onTrack = (RTCTrackEvent event)  {
      if (event.track.kind == "video") {
        setState(() {
          _localRenderer.srcObject = event.streams[0];
        });
      }
    };
    peerConnection = pc;

    sc?.connect();
  }

  Future<void> _onSDP(String? type, String? sdpText) async {
    if (peerConnection != null) {
      var sdp = RTCSessionDescription(sdpText, type);
      await peerConnection!.setRemoteDescription(sdp);

      await peerConnection!.createAnswer().then(
        (sdp) => peerConnection!.setLocalDescription(sdp).then(
          (_) async {
            var localSdp = await peerConnection!.getLocalDescription();
            sc?.send(jsonEncode({
            "type": "sdp",
            "data": localSdp!.toMap(),
            }));
          } 
        )
      );
    }
  }

  Future<void> _onICE(String? candidate, String? sdpMid, int? sdpMLineIndex)  async {
    if (peerConnection != null) {
      var ice = RTCIceCandidate(candidate, sdpMid, sdpMLineIndex);
      await peerConnection!.addCandidate(ice);
    }
  }

  @override
  Widget build(BuildContext context) {
    _connect();
    return Scaffold(
        appBar: AppBar(
          title: const Text('rd'),
        ),
        body: RTCVideoView(_localRenderer),
        // body: const Center(
        //   child: Text('xxxxxx'),
        // ));
    );
  }
}
