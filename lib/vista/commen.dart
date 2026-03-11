import 'package:clase5/vista/crear_persona.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clase5/modelo/comentario.dart';
import 'package:clase5/controlador/autenticar.dart';

class ComentarioScreen extends StatefulWidget {
  @override
  _ComentarioScreenState createState() => _ComentarioScreenState();
}

class _ComentarioScreenState extends State<ComentarioScreen> {
  String nombreUsuario = '';
  String? role;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchUserRole();
  }

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? name = await AuthServices().getUserName(user.uid);
      if (name != null) {
        setState(() {
          nombreUsuario = name;
        });
      }
    }
  }

  Future<void> fetchUserRole() async {
    String? userRole = await _getUserRole();
    if (userRole != null) {
      setState(() {
        role = userRole;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Image.network(
              'https://static.wixstatic.com/media/04b44a_b366ba583f014f019532598992cccace~mv2.png/v1/fill/w_708,h_169,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Logo%20versi%C3%B3n%202%20Eventos%20Colibr%C3%AD_4x_edited.png',
              height: 50,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.keyboard_return_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('coment')
                .orderBy('timestamp',
                    descending:
                        true) // Ordenar por timestamp en orden descendente
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

              final coments = snapshot.data!.docs
                  .map((doc) => COMMENT.fromFirestore(doc))
                  .toList();

              return ListView.builder(
                itemCount: coments.length,
                itemBuilder: (context, index) {
                  final coment = coments[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.comment,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(coment.nombre),
                        subtitle: Text(coment.comentario),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: role != "Empleado" &&
                  role != "Admin" &&
                  role != null
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CrearPersonaForm(nombreUsuario: nombreUsuario)),
                    );
                  },
                  child: Icon(Icons.add),
                )
              : null,
        ),
      ),
    );
  }
}
