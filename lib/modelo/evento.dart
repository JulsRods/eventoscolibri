import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  final String id; // Agregamos un id para identificar el documento en Firestore
  final String nombre;
  final String apellido;
  final String email;
  final String celular;
  final String organizacion;
  final String nombreSalon;
  final DateTime fechaEvento;
  final String necesidades;
  final String extras;

  Evento({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.celular,
    required this.organizacion,
    required this.nombreSalon,
    required this.fechaEvento,
    required this.necesidades,
    required this.extras,
  });

  // Constructor que permite crear un Evento desde un documento de Firestore
  factory Evento.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Evento(
      id: doc.id,
      nombre: data['nombre'],
      apellido: data['apellido'],
      email: data['email'],
      celular: data['celular'],
      organizacion: data['organizacion'],
      nombreSalon: data['nombreSalon'],
      fechaEvento: (data['fechaEvento'] as Timestamp).toDate(),
      necesidades: data['necesidades'],
      extras: data['extras'],
    );
  }

  // Método que permite convertir un Evento a un formato que Firestore pueda almacenar
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'celular': celular,
      'organizacion': organizacion,
      'nombreSalon': nombreSalon,
      'fechaEvento': fechaEvento,
      'necesidades': necesidades,
      'extras': extras,
    };
  }
}
