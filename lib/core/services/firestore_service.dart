import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String get uid => _auth.currentUser!.uid;

  static DocumentReference userDoc() => userDocById(uid);

  static DocumentReference userDocById(String id) =>
      _db.collection('users').doc(id);
}
