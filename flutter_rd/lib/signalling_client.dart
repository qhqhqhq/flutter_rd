import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignallingClient {
  String _server;
  String _peer_id;
  late WebSocketChannel _ws_conn; // TODO

  void Function(String)? handleMessage;

  SignallingClient(this._server, this._peer_id) {
    // _ws_conn = WebSocket(_server);
    _ws_conn = WebSocketChannel.connect(
      Uri.parse(_server),
    );
  }

  void send(String msg) {
    _ws_conn.sink.add(msg);
  }

  Future<void> connect() async {
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmQiLCJleHAiOjE3MDY3NDg5NDh9.o5Tj2wKUl5uqx99zvS0Qf-FlG9DExn5Qa0135bWHjvQ";
    _ws_conn.sink.add(jsonEncode(
      {
        "type": "hello",
        "data": {
          "id": _peer_id,
          "token": token,
        }
      }
    ));
    _ws_conn.stream.listen((event) {
      if (handleMessage != null) {
        handleMessage!(event.toString());
      }

    });
    // _ws_conn.onOpen.listen((event) {
    //   var hello = {
    //     "type": "hello",
    //     "data": {
    //       "id": _peer_id,
    //       "token": token,
    //     }
    //   };
    //   _ws_conn.send(jsonEncode(hello));
    // });

    // _ws_conn.onMessage.listen((event) {
    //   if (handleMessage != null) {
    //     handleMessage!(event.data.toString());
    //   }
    // });

  }

  void disconnect() {
    _ws_conn.sink.close();
  }
  
}
