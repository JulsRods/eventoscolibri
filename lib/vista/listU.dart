import 'package:clase5/vista/forgot.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class List2Screen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<List2Screen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _deleteUser(String uid, BuildContext scaffoldContext) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(content: Text('Usuario eliminado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(content: Text('Error al eliminar usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .where('rool', isEqualTo: 'Usuario')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ocurrió un error al cargar los datos'));
          }

          final users = snapshot.data?.docs ?? [];

          if (users.isEmpty) {
            return Center(child: Text('No hay usuarios registrados'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final uid = users[index].id; // UID del usuario

              return ListTile(
                title: Text(user['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['email']),
                    Text(user['number']), // Mostrar el número de teléfono
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.email_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotScreen();
                            },
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteUser(uid, context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
