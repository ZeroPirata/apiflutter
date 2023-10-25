import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RenderUserComponent extends StatefulWidget {
  const RenderUserComponent({super.key, required this.user});

  final dynamic user;

  @override
  State<RenderUserComponent> createState() => _RenderUserComponentState();
}

class _RenderUserComponentState extends State<RenderUserComponent> {
  String alert = "";

  bool edit = false;

  @override
  void initState() {
    super.initState();
    edit = false;
  }

  void openEditUser() {
    setState(() {
      edit = !edit;
    });
  }

  Future<void> _editarUser(dynamic user, String name, String email) async {
    int userId = user["id"];
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
    };
    try {
      final response = await http.put(
          Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        setState(() {
          alert = "Usuario alterado para: $data";
        });
        openEditUser();
      } else {
        setState(() {
          alert = "Erro ao alterar o usaurio";
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _deleteData(dynamic user) async {
    try {
      int userId = user["id"];
      String userName = user['name'];
      final response = await http.delete(
          Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          alert = "Usuario $userName foi deleteado com sucesso.";
        });
      } else {
        setState(() {
          alert = "Algo deu errado ao tentar deletar o usuario $userName";
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerName =
        TextEditingController(text: widget.user['name']);
    TextEditingController controllerEmail =
        TextEditingController(text: widget.user['email']);

    dynamic user = widget.user;
    return Column(
      children: [
        Card(
            elevation: 2,
            margin: const EdgeInsets.all(8),
            child: ListTile(
                title: Text(user['name']),
                subtitle: Text(user['email']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        openEditUser();
                      },
                      child: const Text('Editar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteData(user).then((value) => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Deleção de usaurio'),
                                  content: Text(alert),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                )));
                      },
                      child: const Text('Deletar'),
                    ),
                  ],
                ))),
        edit
            ? Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 600,
                        margin: const EdgeInsets.only(left: 18.0),
                        child: TextField(
                          controller: controllerName,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 18.0),
                        width: 600,
                        child: TextField(
                          controller: controllerEmail,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(18.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _editarUser(user, controllerName.text,
                                    controllerEmail.text)
                                .then((value) => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title:
                                              const Text('Edição do usuario'),
                                          content: Text(alert),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        )));
                          },
                          child: const Text('Salvar'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(18.0),
                        child: ElevatedButton(
                          onPressed: () {
                            openEditUser();
                          },
                          child: const Text('Cancelar'),
                        ),
                      )
                    ],
                  )
                ],
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
/*                 edit ? Text(user['name']) : const Text(""),
 */