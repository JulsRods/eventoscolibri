import 'package:clase5/modelo/preguntas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FaqService {
  final CollectionReference _faqCollection =
      FirebaseFirestore.instance.collection('faq');

  Future<List<FAQ>> getEventos() async {
    QuerySnapshot querySnapshot =
        await _faqCollection.orderBy('createdAt').get();
    return querySnapshot.docs.map((doc) => FAQ.fromFirestore(doc)).toList();
  }

  // Agregar un nuevo evento
  Future<void> addEvento(FAQ faq) {
    return _faqCollection.add(faq.toFirestore());
  }

// Actualizar un evento existente
  Future<void> updateEvento(FAQ faq) {
    return _faqCollection.doc(faq.id).update(faq.toFirestore());
  }

  Future<void> deleteEvento(String id) {
    return _faqCollection.doc(id).delete();
  }
}
