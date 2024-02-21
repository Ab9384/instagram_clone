import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/firebase/database_function.dart';
import 'package:instagram_clone/functions/toast_function.dart';
import 'package:instagram_clone/models/user_model.dart';

class AuthFunction {
  // sigup email and password
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<bool> signUpWithEmailAndPassword(
      String email, String password, context) async {
    bool isSignedUp = false;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      if (e.toString().contains('email-already-in-use')) {
        ToastFunction.showRedToast(context, 'Email already in use');
      } else if (e.toString().contains('invalid-email')) {
        ToastFunction.showRedToast(context, 'Invalid email');
      } else if (e.toString().contains('weak-password')) {
        ToastFunction.showRedToast(context, 'Weak password');
      } else {
        ToastFunction.showRedToast(context, e.toString());
      }
      return isSignedUp;
    }
    UserModel userModel = UserModel(
      userId: auth.currentUser!.uid,
      email: auth.currentUser!.email,
      username: null,
      bio: null,
      followers: [],
      following: [],
    );
    try {
      await DatabaseFunctions.addUserData(userModel.toJson());
    } catch (e) {
      ToastFunction.showRedToast(context, e.toString());
    }
    isSignedUp = true;
    return isSignedUp;
  }

  // sign in email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  // reset password
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  // verify email
  Future<void> verifyEmail() async {
    await auth.currentUser!.sendEmailVerification();
  }

  // change password
  Future<void> changePassword(String password) async {
    await auth.currentUser!.updatePassword(password);
  }

  // change email
  Future<void> changeEmail(String email) async {
    await auth.currentUser!.verifyBeforeUpdateEmail(
      email,
    );
  }

  // delete account
  Future<void> deleteAccount() async {
    await auth.currentUser!.delete();
  }

  // get current user
  User? getCurrentUser() {
    return auth.currentUser;
  }
}
