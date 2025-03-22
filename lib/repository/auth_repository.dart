import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:next_door/constants/constants.dart';
import 'package:next_door/models/user_model.dart';

/// Exception thrown when the email provided is already in use
class EmailAlreadyInUseException implements Exception {}

/// Exception thrown when the email provided is invalid
class InvalidEmailException implements Exception {}

/// Exception thrown when the password provided is too weak
class WeakPasswordException implements Exception {}

/// Exception thrown when the user is not found
class UserNotFoundException implements Exception {}

/// Exception thrown when the password provided is wrong
class WrongPasswordException implements Exception {}

/// Exception thrown when networks issues prevent authentication
class NetworkException implements Exception {}

/// Exception thrown for any other authentication error
class GenericAuthException implements Exception {}

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  /// Stream of [UserModel] which will emit the current user when the authentication state changes
  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return UserModel.empty;
      }
      return await _getUserFromFirestore(firebaseUser.uid) ??
          UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  /// Fetch user from Firestore by ID
  Future<UserModel?> _getUserFromFirestore(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      log('Error fetching user from Firestore: $e');
      return null;
    }
  }

  /// Returns the current user
  Future<UserModel> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return UserModel.empty;
    }

    // Try to get user from Firestore first
    final firestoreUser = await _getUserFromFirestore(firebaseUser.uid);
    if (firestoreUser != null) {
      return firestoreUser;
    }

    // Fallback to creating from Firebase user
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  // Register user with Email and Password
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("Firebase sign-up success: ${userCredential.user?.uid}");

      final user = userCredential.user;
      if (user == null) {
        throw GenericAuthException();
      }

      await user.updateDisplayName('$firstname $lastname');

      // Create user document in Firestore
      final newUser = UserModel(
        id: user.uid,
        firstname: firstname,
        lastname: lastname,
        email: email,
        profileImageUrl: user.photoURL,
        location: null,
        address: null,
        isLocationSet: false,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await firestore.collection('users').doc(user.uid).set(newUser.toMap());
      return newUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkException();
      }
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
