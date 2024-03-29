import 'package:flutter/material.dart';
import 'remote_desktop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/':(context) => const MyHomePage(),
        '/rd':(context) => const RemoteDesktop(),
      }
    );
  }
}

class MyHomePage extends StatelessWidget{
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(134, 153, 179, 1),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 350,
          child: Card(
            child: MyLoginPage(title: 'login'),
          ),
        ),
      ),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<MyLoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _formFinished = false;

  void _formChanged(){
    if(_username.value.text.isNotEmpty&&_password.value.text.isNotEmpty){
      setState(() {
        _formFinished = true;
      });
    }
  }

  void _navi(){
    Navigator.of(context).pushNamed('/rd');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _formChanged,
      child: Column(
        children: [
          Text('Login', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _username,
              decoration: const InputDecoration(hintText: 'input username'),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _password,
              decoration: const InputDecoration(hintText: 'input password'),
            )
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: _formFinished ? _navi : null ,
            child: const Text('Login'),
          )
        ],
      ),
    );
  }
}
