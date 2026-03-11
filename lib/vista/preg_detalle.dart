import 'package:flutter/material.dart';
import 'package:clase5/modelo/preguntas.dart';

class FaqDetallesScreen extends StatelessWidget {
  final FAQ preguntas;

  FaqDetallesScreen({required this.preguntas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(preguntas.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                child: Icon(
                  Icons.question_mark,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              preguntas.nombre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Respuesta: ${preguntas.res}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
