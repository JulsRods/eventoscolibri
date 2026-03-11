import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose( ){
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset () async {
    try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    showDialog(context: context,
      builder: (context){
        return AlertDialog(
          content: Text('Enviado correctamente. Revise su email'),
        );
      });
    } on FirebaseAuthException catch (e){
      print(e);
      showDialog(context: context,
      builder: (context){
        return AlertDialog(
          content: Text('No existe ningún registro de usuario correspondiente a este identificador.'),
        );
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
              'Ingrese correo correspondiente y se enviará un enlace para restablecer o cambiar su contraseña',
              textAlign: TextAlign.center,
              ),
                 SizedBox(height: 10,),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: 'Correo',
                  fillColor: Colors.grey,
                  filled: true,
                ),
              ),
              ),
              SizedBox(height: 10,),
              MaterialButton(onPressed: passwordReset,
              child: Text('Restablecer contraseña'),
              color: Colors.greenAccent,
              )
        ]));
  }
}
