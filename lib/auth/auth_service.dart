import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/models/user.dart';

class AuthService {
  // List<String> usernames = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserAccount> SignUp(
      String username, String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user.user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.user?.uid)
            .set({'username': username, 'email': email});
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc('userlist')
              .update({
            'users': FieldValue.arrayUnion(
              [username],
            ),
          });
        } catch (e) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc('userlist')
              .set({
            'users': [username],
          });
        }
        _auth.currentUser?.sendEmailVerification();
        FirebaseAnalytics.instance.logEvent(name: 'Signed Up');
        return UserAccount(
            email: email, username: username, uid: user.user!.uid);
      } else {
        return Future.error('Error Signing In');
      }
    } catch (e) {
      return Future.error('Error Signing In !');
    }
  }

  Future<UserAccount> SignIn(
      {required String email, required String password}) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user.user != null) {
        try {
          DocumentSnapshot userdoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.user?.uid)
              .get();
          String username = userdoc['username'].toString();
          return UserAccount(
              email: email, username: username, uid: user.user!.uid);
        } catch (e) {
          return UserAccount(email: email, username: "", uid: user.user!.uid);
        }
      } else {
        return Future.error('Error Signing In');
      }
    } catch (e) {
      return Future.error('Error Signing In !');
    }
  }

  Future<UserAccount?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userdoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        String username = userdoc['username'].toString();
        if (!user.uid.isEmpty) {
          return UserAccount(
              email: user.email ?? "", username: username, uid: user.uid);
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<List<String>> GetUsernames() async {
    try {
      DocumentSnapshot userdoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('userlist')
          .get();
      List<String> users = [];
      userdoc['users'].forEach((e) => users.add(e));
      return users;
    } catch (e) {
      return Future.error('Trouble getting user list');
    }
  }

  Stream<User?> AuthStream() {
    return _auth.userChanges();
  }

  Future<void> Signout() async {
    _auth.signOut();
  }
}
