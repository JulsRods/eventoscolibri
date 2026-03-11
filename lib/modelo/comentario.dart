import 'package:cloud_firestore/cloud_firestore.dart';

class COMMENT {
  String id;
  String nombre;
  String comentario;
  Timestamp timestamp;

  COMMENT({
    required this.id,
    required this.nombre,
    required this.comentario,
    required this.timestamp,
  });

  factory COMMENT.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return COMMENT(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      comentario: data['comentario'] ?? '',
      timestamp:
          data['timestamp'] ?? Timestamp.now(), // Añade el campo timestamp
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'comentario': comentario,
      'timestamp': timestamp,
    };
  }
}
