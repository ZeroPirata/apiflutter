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
    dynamic user = widget.user;
    return Card(
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
                    // Lógica para o botão "Editar"
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
            )));
  }
}
