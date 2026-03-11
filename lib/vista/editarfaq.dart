import 'package:clase5/controlador/faq_serv.dart';
import 'package:flutter/material.dart';
import 'package:clase5/modelo/preguntas.dart';

class EditarFaqScreen extends StatefulWidget {
  final FAQ faq;

  EditarFaqScreen({required this.faq});

  @override
  _EditarFaqScreenState createState() => _EditarFaqScreenState();
}

class _EditarFaqScreenState extends State<EditarFaqScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _resController;
  final _faqService = FaqService();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.faq.nombre);
    _resController = TextEditingController(text: widget.faq.res);
  }

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
        title: Text('Editar FAQ'),
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
                    final updatedFaq = FAQ(
                      id: widget.faq.id,
                      nombre: _nombreController.text,
                      res: _resController.text,
                    );

                    await _faqService.updateEvento(updatedFaq);

                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
