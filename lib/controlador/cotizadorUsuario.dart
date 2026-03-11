import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clase5/modelo/cotizacion.dart';

class CotizacionUService {
  final CollectionReference _cotizacionCollection =
      FirebaseFirestore.instance.collection('cotizadorU');

  Future<void> addCotizacion(Cotizacion cotizacion) {
    return _cotizacionCollection.add(cotizacion.toFirestore());
  }

  Future<List<Cotizacion>> getCotizaciones() async {
    QuerySnapshot querySnapshot = await _cotizacionCollection.get();
    return querySnapshot.docs
        .map((doc) => Cotizacion.fromFirestore(doc))
        .toList();
  }

  Stream<List<Cotizacion>> getCotizacionesStream() {
    return _cotizacionCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Cotizacion.fromFirestore(doc)).toList());
  }

  Future<void> deleteCotizacion(String id) async {
    await _cotizacionCollection.doc(id).delete();
  }

  Future<void> updateField(
      String collection, String docId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update(data);
  }

  Future<void> deleteField(
      String collection, String docId, String field) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({field: FieldValue.delete()});
  }

  Future<void> addNewField(
      String collection, String docId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> getTipoEventos() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('tipoEventos').get();
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs[0];
      var tipoEventosData = doc.data();
      if (tipoEventosData != null) {
        return tipoEventosData as Map<String, dynamic>;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> getDuracionEvento() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('duracionevento').get();
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs[0];
      var duracionEventosData = doc.data();
      if (duracionEventosData != null) {
        return duracionEventosData as Map<String, dynamic>;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> getServiciosAdicionales() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('serviciosAdicionales')
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs[0];
      var serviciosAdd = doc.data();
      if (serviciosAdd != null) {
        return serviciosAdd as Map<String, dynamic>;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> getNecesidades() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('necesidades').get();
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs[0];
      var necesidades = doc.data();
      if (necesidades != null) {
        return necesidades as Map<String, dynamic>;
      }
    }
    return {};
  }
}
