import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clase5/modelo/preguntas.dart';
import 'package:clase5/vista/preg_detalle.dart';
import 'package:clase5/vista/craerfaq.dart';
import 'package:clase5/vista/editarfaq.dart';
import 'package:clase5/controlador/faq_serv.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqService _faqService = FaqService();

  Future<String?> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        return userDoc['rool'];
      }
    }
    return null;
  }

  void _eliminarFaq(String id) {
    _faqService.deleteEvento(id).then((_) {
      setState(() {
// Actualiza la UI después de eliminar
      });
    }).catchError((error) {
// Maneja cualquier error si ocurre durante la eliminación
      print('Error eliminando FAQ: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Preguntas Frecuentes'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Preguntas Frecuentes'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final String? role = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text('Preguntas Frecuentes'),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('faq')
                .orderBy('nombre')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final faqs = snapshot.data!.docs
                  .map((doc) => FAQ.fromFirestore(doc))
                  .toList();

              // Ordenar faqs por el nombre
              faqs.sort((a, b) => a.nombre.compareTo(b.nombre));

              return ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.question_mark,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(faq.nombre),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FaqDetallesScreen(preguntas: faq),
                            ),
                          );
                        },
                        trailing: role == "Empleado" || role == "Admin"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditarFaqScreen(faq: faq),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Confirmar eliminación'),
                                          content: Text(
                                              '¿Estás seguro de que deseas eliminar esta Pregunta?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _eliminarFaq(faq.id);
                                              },
                                              child: Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: role == "Empleado" || role == "Admin"
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CrearFaqScreen()),
                    );
                  },
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
