import 'package:events_dashboard/models/data_models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerAdmin(String email, String password, String name, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('admins').doc(email).set({
        'email': email,
        'name': name,
        'phone': phone,
        'id': userCredential.user!.uid,
        'registerTime': DateTime.now(),
      });

      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _firestore.collection('admins').where('email', isEqualTo: email).get().then((value) {
        if (value.docs.isEmpty) {
          throw Exception("Admin not found");
        }
      });
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getAdminDetails(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('admins').doc(uid).get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<void> addAdmin(UserModel user) async {
    await _firestore.collection('admin').add(user.toMap());
  }

  Future<void> updateAdmin(UserModel user) async {
    await _firestore.collection('admin').doc(user.id).update(user.toMap());
  }

  Future<void> deleteAdmin(String uid) async {
    await _firestore.collection('admin').doc(uid).delete();
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isEmailVerified() async {
    await _auth.currentUser!.reload();
    return _auth.currentUser!.emailVerified;
  }
}
