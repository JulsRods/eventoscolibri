import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clase5/modelo/salon.dart';

class SalonService {
  final CollectionReference _salonCollection =
      FirebaseFirestore.instance.collection('salon');

  Stream<List<Salon>> getSalonesStream() {
    return _salonCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Salon.fromFirestore(doc)).toList());
  }

  Stream<Salon> getSalonStream(String salonId) {
    return _salonCollection.doc(salonId).snapshots().map((snapshot) {
      return Salon.fromFirestore(snapshot);
    });
  }

  Future<void> addSalon(Salon salon) {
    return _salonCollection.add(salon.toFirestore());
  }

  Future<void> updateSalon(Salon salon) {
    return _salonCollection.doc(salon.id).update(salon.toFirestore());
  }

  Future<void> deleteSalon(String id) {
    return _salonCollection.doc(id).delete();
  }
}
