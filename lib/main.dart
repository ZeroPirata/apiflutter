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
      darkTheme: ThemeData.dark(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeUser(title: 'GM Duo'),
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

  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerEmail = TextEditingController(text: "");
  String alert = "";

  Future<void> _createUser(String name, String email) async {
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
    };

    if (controllerName.text.isEmpty || controllerEmail.text.isEmpty) {
      setState(() {
        alert = "Por favor, insira os dados obrigatórios.";
      });
    } else {
      try {
        final response = await http.post(
            Uri.parse(
              'https://jsonplaceholder.typicode.com/users',
            ),
            headers: {
              'Content-type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data));
        if (response.statusCode == 201) {
          setState(() {
            alert = "Usuário cadastrado com as informações: $data.";
          });
        } else {
          setState(() {
            alert = "Erro ao cadastrar novo usuário.";
          });
        }
      } catch (error) {
        // ignore: avoid_print
        print(error);
      }
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
            const SizedBox(
              height: 16.0,
            ),
            Container(
              width: 600,
              margin: const EdgeInsets.only(left: 18.0),
              child: TextField(
                controller: controllerName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Entre com o nome',
                  prefixIcon: Icon(Icons.account_circle_rounded,
                      color: Colors.deepPurple),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              width: 600,
              margin: const EdgeInsets.only(left: 18.0),
              child: TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Entre com o email',
                  prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(
                      color: Colors.deepPurple, // Cor da borda
                      width: 0.5, // Largura da borda
                    ),
                  ),
                ),
                onPressed: () {
                  _createUser(controllerName.text, controllerEmail.text)
                      .then((value) => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: (controllerName.text.isEmpty ||
                                        controllerEmail.text.isEmpty)
                                    ? const Text('Campos obrigatórios vazios')
                                    : const Text('Usuário cadastrado!'),
                                content: Text(alert),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancelar'),
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              )));
                  ;
                },
                child: const Text('Novo usuário'),
              ),
            ),
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
