import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('data');

  Stream<QuerySnapshot> getData() {
    return collection.snapshots();
  }

  Future<void> addData(String name) async {
    await collection.add({'name': name});
  }

  Future<void> deleteData(String id) async {
    await collection.doc(id).delete();
  }
}
