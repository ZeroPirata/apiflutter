import 'dart:convert';

import 'package:apiflutter/components/render_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeUser(title: 'Duo'),
    );
  }
}

class HomeUser extends StatefulWidget {
  const HomeUser({super.key, required this.title});
  final String title;
  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        setState(() {
          _data = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic currentUser = _data[index];
                  return RenderUserComponent(user: currentUser);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
