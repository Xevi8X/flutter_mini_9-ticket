import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../common.dart';
import '../main.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? currentUser()
  {
    return _auth.currentUser;
  }

  Stream<User?>get user
  {
    return _auth.authStateChanges();
  }

  Future<User?> signInAnonymously() async
  {
    try
    {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInEmailPassword(String email, String password, BuildContext context) async
  {
    try
    {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Common.myShowAlert(context,"No user found");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Common.myShowAlert(context,"Wrong password");
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserCredential?> registerEmailPassword(String email, String password, BuildContext context) async
  {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Common.myShowAlert(context,"Weak password");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Common.myShowAlert(context,"Email already exist (WTF??)");
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async
  {
    try
    {
      return await _auth.signOut();
    }
    catch(e)
    {
      print(e.toString());
      return;
    }
  }

  void signOutIfAnonymous()
  {
    User? user = _auth.currentUser;
    if(user != null && user.isAnonymous) signOut();
  }

  Future<bool> checkIfEmailExist(String email) async
  {
    try
    {
      await _auth.signInWithEmailAndPassword(email: email, password: "123");
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      } else if (e.code == 'wrong-password') {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return true;
  }
}