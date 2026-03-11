import 'package:clase5/vista/forgot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addUser(BuildContext scaffoldContext) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController passwordController = TextEditingController(); // Nuevo controlador para la contraseña
    TextEditingController roolController = TextEditingController(text: 'Empleado'); // Default value as 'Empleado'

    await showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Añadir Nuevo Empleado'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Correo Electrónico'),
                ),
                TextField(
                  controller: numberController,
                  decoration: InputDecoration(labelText: 'Número de Teléfono'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true, // Para ocultar la contraseña
                ),
                TextField(
                  controller: roolController,
                  decoration: InputDecoration(labelText: 'Rol'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    // Validación básica para asegurar que los campos requeridos no estén vacíos
                    if (nameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        roolController.text.isNotEmpty) {
                      // Crear cuenta de usuario en Firebase Authentication
                      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      // Guardar los datos del empleado en Firestore
                      await _firestore.collection('users').doc(userCredential.user!.uid).set({
                        'name': nameController.text,
                        'email': emailController.text,
                        'number': numberController.text,
                        'rool': roolController.text,
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Nuevo empleado añadido')),
                      );
                    } else {
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Por favor, complete todos los campos')),
                      );
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Error al añadir empleado: $e')),
                    );
                  }
                },
                child: Text('Añadir'),
              ),
            ],
          ),
        );
      },
    );
  }

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
        title: Text('Lista de Empleados'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').where('rool', isEqualTo: 'Empleado').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ocurrió un error al cargar los datos'));
          }

          final users = snapshot.data?.docs ?? [];

          if (users.isEmpty) {
            return Center(child: Text('No hay empleados registrados'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final uid = users[index].id; // UID del usuario

              return ListTile(
                title: Text(user['name']),
                subtitle: Text(user['email']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addUser(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}











