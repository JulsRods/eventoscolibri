import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String number,
    required String rool,
  }) async {
    String res = "Ocurrió un error";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          name.isNotEmpty &&
          number.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _firestore.collection("users").doc(credential.user!.uid).set({
          "name": name,
          "email": email,
          "number": number,
          "rool": rool,
          "uid": credential.user!.uid,
        });
        res = "success";
      } else {
        res = "Por favor, rellene todos los campos";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        res = "El correo electrónico ya está en uso";
      } else if (e.code == 'weak-password') {
        res = "La contraseña es demasiado débil";
      } else if (e.code == 'invalid-email') {
        res = "El correo electrónico no es válido";
      } else {
        res = e.message ?? "Ocurrió un error";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Ocurrió un error";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // Obtiene el rol del usuario
        String? role = await getUserRole(userCredential.user!.uid);
        if (role != null) {
          await saveUserRole(role);
        }

        res = "success";
      } else {
        res = "Por favor ingrese todos los datos";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
  }

  Future<String?> getUserName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['name'];
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['rool'];
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  Future<String?> getUserRoleFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }
}
