import 'package:expense_logger/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null && firebaseUser.isEmailVerified
        ? User(uid: firebaseUser.uid)
        : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anonymously
  Future<User> signInAnonymously() async {
    try {
      AuthResult authResult = await _firebaseAuth.signInAnonymously();
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      if (firebaseUser.isEmailVerified) {
        return _userFromFirebaseUser(firebaseUser);
      } else {
        return 'Email verfication is pending...!';
      }
    } catch (e) {
      print(e.toString());
      return _getErroMessage(e.code);
    }
  }

  // sign in with google
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return _getErroMessage(e.code);
    }
  }

  //sign out from google
  void signOutFromGoogle() async {
    print('google signout');
    await _googleSignIn.signOut();
    signOut();
  }

  // is signed in with google
  Future<bool> isSignInWithGoogle() async {
    return await _googleSignIn.isSignedIn();
  }

  // register with email and password
  Future registerUserWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      await firebaseUser.sendEmailVerification();
      if (firebaseUser.isEmailVerified) {
        return _userFromFirebaseUser(firebaseUser);
      } else {
        return 'Please verify the email through the link sent to the registered email address';
      }
    } catch (e) {
      print(e.toString());
      return _getErroMessage(e.code);
    }
  }

  // forgot password
  Future resetPassword(BuildContext context, String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return _getErroMessage(e.code);
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // user readable error message
  String _getErroMessage(String code) {
    switch (code) {
      case 'ERROR_INVALID_EMAIL':
        return 'Enter a valid email address';
        break;
      case 'ERROR_USER_NOT_FOUND':
        return 'No user found with those credentials';
        break;
      case 'ERROR_WRONG_PASSWORD':
        return 'Email/Pasword are incorrect';
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'Email is already in use';
        break;
      default:
        return 'Authentication Failed. Please try again!!!';
        break;
    }
  }
}
