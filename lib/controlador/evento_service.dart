import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clase5/modelo/evento.dart';

class EventoService {
  final CollectionReference _eventoCollection =
      FirebaseFirestore.instance.collection('evento');

  // Obtener todos los eventos como Stream y ordenados por fecha
  Stream<List<Evento>> getEventosStream() {
    return _eventoCollection.orderBy('fechaEvento').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Evento.fromFirestore(doc)).toList();
    });
  }

  Stream<Evento> getEventoStream(String eventId) {
    return _eventoCollection.doc(eventId).snapshots().map((snapshot) {
      return Evento.fromFirestore(snapshot);
    });
  }

  // Agregar un nuevo evento
  Future<void> addEvento(Evento evento) {
    return _eventoCollection.add(evento.toFirestore());
  }

  // Actualizar un evento existente
  Future<void> updateEvento(Evento evento) {
    return _eventoCollection.doc(evento.id).update(evento.toFirestore());
  }

  // Eliminar un evento
  Future<void> deleteEvento(String id) {
    return _eventoCollection.doc(id).delete();
  }
}
