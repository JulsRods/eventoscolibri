import 'package:cloud_firestore/cloud_firestore.dart';

class FAQ {
  final String id; // Agregamos un id para identificar el documento en Firestore
  final String nombre;
  final String res;

  FAQ({
    required this.id,
    required this.nombre,
    required this.res,
  });

  // Constructor que permite crear un Evento desde un documento de Firestore
  factory FAQ.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FAQ(
      id: doc.id,
      nombre: data['nombre'],
      res: data['res'],
    );
  }

  // Método que permite convertir un Evento a un formato que Firestore pueda almacenar
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'res': res,
    };
  }
}
