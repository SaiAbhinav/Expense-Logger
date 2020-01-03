import 'package:expense_logger/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? User(uid: firebaseUser.uid) : null;
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
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {  
      print(e.toString());    
      return e.message;
    }
  }

  // register with email and password
  Future registerUserWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return e.message;     
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}