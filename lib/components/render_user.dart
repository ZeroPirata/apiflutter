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

    if (name == "" || email == "") {
      setState(() {
        alert = "Por favor, preencha os campos obrigatórios.";
      });
    } else {
      try {
        final response = await http.put(
            Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
            headers: {
              'Content-type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          setState(() {
            alert = "Usuário alterado para: $data.";
          });
          openEditUser();
        } else {
          setState(() {
            alert = "Erro ao alterar o usuário.";
          });
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
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
          alert = "Usuário $userName foi deleteado com sucesso.";
        });
      } else {
        setState(() {
          alert = "Algo deu errado ao tentar deletar o usuário $userName.";
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
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: Colors.deepPurple, // Cor da borda
                            width: 0.5, // Largura da borda
                          ),
                        ),
                      ),
                      onPressed: () {
                        openEditUser();
                      },
                      child: const Text('Editar'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: Colors.deepPurple, // Cor da borda
                            width: 0.5, // Largura da borda
                          ),
                        ),
                      ),
                      onPressed: () {
                        _deleteData(user).then((value) => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Usuário deletado!'),
                                  content: Text(alert),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancelar'),
                                      child: const Text('Cancelar'),
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
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Entre com o nome a ser atualizado',
                            prefixIcon: Icon(Icons.account_circle_rounded,
                                color: Colors.deepPurple),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
                            ),
                          ),
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
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Entre com o email a ser atualizado',
                            prefixIcon:
                                Icon(Icons.email, color: Colors.deepPurple),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(18.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(
                                color: Colors.deepPurple, // Cor da borda
                                width: 0.5, // Largura da borda
                              ),
                            ),
                          ),
                          onPressed: () {
                            _editarUser(user, controllerName.text,
                                    controllerEmail.text)
                                .then((value) => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: (controllerName.text.isEmpty ||
                                                  controllerEmail.text.isEmpty)
                                              ? const Text(
                                                  'Campos obrigatórios vazios')
                                              : const Text(
                                                  'Usuário atualizado!'),
                                          content: Text(alert),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancelar'),
                                              child: const Text('Cancelar'),
                                            ),
                                          ],
                                        )));
                          },
                          child: const Text('Salvar'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.all(18.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(
                                color: Colors.deepPurple, // Cor da borda
                                width: 0.5, // Largura da borda
                              ),
                            ),
                          ),
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
