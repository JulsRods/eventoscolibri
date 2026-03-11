import 'package:clase5/controlador/faq_serv.dart';
import 'package:flutter/material.dart';
import 'package:clase5/modelo/preguntas.dart';

class CrearFaqScreen extends StatefulWidget {
  @override
  _CrearFaqScreenState createState() => _CrearFaqScreenState();
}

class _CrearFaqScreenState extends State<CrearFaqScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _resController = TextEditingController();
  final _faqService = FaqService(); // Instancia del servicio de FAQ

  @override
  void dispose() {
    _nombreController.dispose();
    _resController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear FAQ'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Pregunta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la pregunta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _resController,
                decoration: InputDecoration(labelText: 'Respuesta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la respuesta';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Crear FAQ
                    final newFaq = FAQ(
                      id: '',
                      nombre: _nombreController.text,
                      res: _resController.text,
                    );

                    // Guardar FAQ en Firestore
                    await _faqService.addEvento(newFaq);

                    // Volver a la pantalla anterior
                    Navigator.pop(context);
                  }
                },
                child: Text('Crear FAQ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
