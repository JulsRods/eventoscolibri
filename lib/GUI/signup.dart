import 'dart:io';
import 'package:clase5/GUI/clientehome.dart';
import 'package:clase5/GUI/login.dart';
import 'package:clase5/controlador/autenticar.dart';
import 'package:clase5/widgets/buttom.dart';
import 'package:clase5/widgets/snackbar.dart';
import 'package:clase5/widgets/text_file.dart';
import 'package:flutter/material.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignuState();
}

class _SignuState extends State<SignScreen> {
  _SignuState();

  bool showProgress = false;
  bool visible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  File? file;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    numberController.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      number: numberController.text,
      rool: "Usuario",
    );

    if (res == "success") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeC()));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  icon: Icons.email),
              TextFieldInpute(
                  textEditingController: passwordController,
                  hintText: 'Ingrese su contraseña',
                  isPass: true,
                  icon: Icons.lock),
              TextFieldInpute(
                  textEditingController: nameController,
                  hintText: 'Ingrese su nombre',
                  icon: Icons.person),
              TextFieldInpute(
                  textEditingController: numberController,
                  hintText: 'Ingrese su número de teléfono',
                  icon: Icons.phone),
              MyButtons(
                onTab: () {
                  signUpUser();
                },
                text: "Crear",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ya tienes una cuenta?",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Inicia Sesión",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
