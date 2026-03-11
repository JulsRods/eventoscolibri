import 'package:clase5/controlador/coment.dart';
import 'package:flutter/material.dart';
import 'package:clase5/modelo/comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearPersonaForm extends StatefulWidget {
  final String nombreUsuario;

  const CrearPersonaForm({
    super.key,
    required this.nombreUsuario,
  });

  @override
  _CrearPersonaFormState createState() => _CrearPersonaFormState();
}

class _CrearPersonaFormState extends State<CrearPersonaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  final TextEditingController _mensajeController = TextEditingController();
  final ComentService _comentService = ComentService();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreUsuario);
  }

  void _crearPersona() async {
    final String nombre = _nombreController.text;
    final String mensaje = _mensajeController.text;

    final nuevoComentario = COMMENT(
      id: '',
      nombre: nombre,
      comentario: mensaje,
      timestamp: Timestamp.now(), // Agrega el timestamp actual
    );

    await _comentService.addComentario(nuevoComentario);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue,
          elevation: 2,
          duration: const Duration(seconds: 3),
          content: Text('Se creó con éxito el comentario: $nombre'),
        ),
      );
    }

    _nombreController.clear();
    _mensajeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Comentario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese el nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mensajeController,
                  decoration: const InputDecoration(labelText: 'Mensaje'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese el mensaje';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (mounted) {
                          _crearPersona();
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text('Crear'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
