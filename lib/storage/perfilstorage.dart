import 'dart:io';

import 'package:clase5/GUI/login.dart';
import 'package:clase5/controlador/autenticar.dart';
import 'package:clase5/vista/forgot.dart';
import 'package:clase5/widgets/buttom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class PerfilPage extends StatefulWidget {
  final String? user;
  const PerfilPage({super.key, this.user});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String? imageUrl;
  String? name;
  String? email;
  String? number;
  String? rool;

  final ImagePicker _imagePicker = ImagePicker();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>?;
          setState(() {
            imageUrl = data != null && data.containsKey('imageUrl')
                ? data['imageUrl']
                : null;
            name = data?['name'];
            email = data?['email'];
            number = data?['number'];
            rool = data?['rool'];
          });
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error loading user data: $e');
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? res =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (res != null) {
      final file = File(res.path);
      if (file.lengthSync() <= 5 * 1024 * 1024) {
        uploadToFirebase(file);
      } else {
        Fluttertoast.showToast(
            msg:
                'La imagen es demasiado grande. Seleccione una imagen de menos de 5 MB.');
      }
    }
  }

  Future<void> uploadToFirebase(File image) async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Reference storageRef = FirebaseStorage.instance.ref().child(
            'Images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.png');
        await storageRef.putFile(image).whenComplete(() {
          Fluttertoast.showToast(msg: 'Image uploaded to Firebase');
        });
        imageUrl = await storageRef.getDownloadURL();
        await _firestore.collection('users').doc(user.uid).set({
          'imageUrl': imageUrl,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error occurred: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil del Usuario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageUrl == null
                    ? const CircleAvatar(
                        radius: 80,
                        child: Icon(
                          Icons.person,
                          size: 80,
                        ),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(imageUrl!),
                      ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text(
                    'Cargar Imagen',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 40),
                if (isLoading)
                  const SpinKitThreeBounce(
                    color: Colors.black,
                    size: 20,
                  ),
                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 40),
                const Text(
                  "Información de Perfil",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name != null ? "Nombre: $name" : 'Nombre no disponible',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  email != null ? "Correo: $email" : 'Email no disponible',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  number != null ? "Numero: $number" : 'Numero no disponible',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Deseas cambiar tu contraseña, da click en el icono ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                MyButtons(
                  onTab: () async {
                    await AuthServices().signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: "Cerrar Sesión",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
