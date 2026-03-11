import 'package:cloud_firestore/cloud_firestore.dart';

class Salon {
  final String id;
  final String nombre;
  final String imagenUrl;
  final int reservaciones;
  final String contacto;
  final int capacidad;
  final String ubicacion;
  final String descripcion;

  Salon({
    this.id = '',
    required this.nombre,
    required this.imagenUrl,
    required this.reservaciones,
    required this.contacto,
    required this.capacidad,
    required this.ubicacion,
    required this.descripcion,
  });

  factory Salon.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Salon(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
      reservaciones: data['reservaciones'] ?? 0,
      contacto: data['contacto'] ?? '',
      capacidad: data['capacidad'] ?? 0,
      ubicacion: data['ubicacion'] ?? '',
      descripcion: data['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'imagenUrl': imagenUrl,
      'reservaciones': reservaciones,
      'contacto': contacto,
      'capacidad': capacidad,
      'ubicacion': ubicacion,
      'descripcion': descripcion,
    };
  }
}
