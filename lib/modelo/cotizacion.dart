import 'package:cloud_firestore/cloud_firestore.dart';

class Cotizacion {
  final String id;
  final String tipoEvento;
  final int numAsistentes;
  final int numInvitados;
  final String duracionEvento;
  final List<String> servicios;
  final List<String> necesidades;
  final double cotizacion;

  Cotizacion({
    required this.id,
    required this.tipoEvento,
    required this.numAsistentes,
    required this.numInvitados,
    required this.duracionEvento,
    required this.servicios,
    required this.necesidades,
    required this.cotizacion,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'tipoEvento': tipoEvento,
      'numAsistentes': numAsistentes,
      'numInvitados': numInvitados,
      'duracionEvento': duracionEvento,
      'servicios': servicios,
      'necesidades': necesidades,
      'cotizacion': cotizacion,
    };
  }

  factory Cotizacion.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Cotizacion(
      id: doc.id, // Aquí obtenemos el ID del documento
      tipoEvento: data['tipoEvento'] ?? '',
      numAsistentes: data['numAsistentes'] ?? 0,
      numInvitados: data['numInvitados'] ?? 0,
      duracionEvento: data['duracionEvento'] ?? '',
      servicios: List<String>.from(data['servicios'] ?? []),
      necesidades: List<String>.from(data['necesidades'] ?? []),
      cotizacion: data['cotizacion'] ?? 0.0,
    );
  }
}
