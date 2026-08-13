import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // LOGIN
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await _createUserIfNotExists(
      credential.user!,
      name: "",
    );
  }

  // REGISTER
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await _createUserIfNotExists(
      credential.user!,
      name: name,
    );
  }

  // CREATE USER DOCUMENT
  Future<void> _createUserIfNotExists(
      User user, {
        required String name,
      }) async {
    final doc = _firestore.collection("users").doc(user.uid);

    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        "id": user.uid,
        "name": name,
        "email": user.email,
        "profileImage": "",
        "isSeller": false,
        "university": "",
        "course": "",
        "semester": "",
        "phone": "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}