import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demeter/models/user.dart' as model;
import 'package:demeter/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  // sign up User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilPics', file, false);

        // add user in database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Logging in User
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        res = "Wrong password";
      } else {
        if (e.code == 'user-not-found') {
          res = "This email is unknown";
        }
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
