import 'package:clase5/GUI/clientehome.dart';
import 'package:clase5/GUI/empleadohome.dart';
import 'package:clase5/GUI/signup.dart';
import 'package:clase5/controlador/autenticar.dart';
import 'package:clase5/widgets/buttom.dart';
import 'package:clase5/widgets/snackbar.dart';
import 'package:clase5/widgets/text_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUsers() async {
    String res = await AuthServices().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = true;
      });
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['rool'];
          // Save session
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', emailController.text);

          if (role == "Empleado" || role == "Admin") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeE()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeC()),
            );
          }
        } else {
          showSnackBar(context, 'No se encontró el rol del usuario');
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      showSnackBar(context, res);
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['rool'];
          if (role == "Empleado" || role == "Admin") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeE()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeC()),
            );
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height / 2.9,
                  child: Image.asset(
                    'assets/images/login.jpg',
                    width: 10,
                    height: 10,
                  ),
                ),
                TextFieldInpute(
                  textEditingController: emailController,
                  hintText: 'Ingrese su correo',
                  icon: Icons.email,
                ),
                TextFieldInpute(
                  textEditingController: passwordController,
                  hintText: 'Ingrese su contraseña',
                  isPass: true,
                  icon: Icons.lock,
                ),
                MyButtons(
                  onTab: () {
                    loginUsers();
                  },
                  text: "Iniciar Sesión",
                ),
                SizedBox(
                  height: height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No tienes una cuenta?",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Crea Una",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
