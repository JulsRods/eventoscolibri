import 'package:clase5/modelo/comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComentService {
  final CollectionReference _comentCollection =
      FirebaseFirestore.instance.collection('coment');

  // Obtener todos los comentarios
  Future<List<COMMENT>> getComentarios() async {
    QuerySnapshot querySnapshot = await _comentCollection.get();
    return querySnapshot.docs.map((doc) => COMMENT.fromFirestore(doc)).toList();
  }

  // Agregar un nuevo comentario
  Future<void> addComentario(COMMENT coment) {
    return _comentCollection.add(coment.toFirestore());
  }

  // Actualizar un comentario existente
  Future<void> updateComentario(COMMENT coment) {
    return _comentCollection.doc(coment.id).update(coment.toFirestore());
  }

  // Eliminar un comentario
  Future<void> deleteComentario(String id) {
    return _comentCollection.doc(id).delete();
  }
}
