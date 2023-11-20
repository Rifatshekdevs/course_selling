// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/auth/login_screen.dart';
import 'package:course_app/screen/course/course_screen.dart';
import 'package:course_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthProviderState extends ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool get loading => isLoading;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  login(BuildContext context) async {
    try {
      setLoading(true);
      CircularProgressIndicator();
      await auth.signInWithEmailAndPassword(
          email: email.value.text.trim(), password: password.value.text.trim());
      setLoading(false);
      Utils.snackBar("Login successfully", context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseScreen(),
          ));
    } catch (e) {
      setLoading(false);
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case "user-not-found":
            Utils.flushBarErrorMessage(
                "No user found for that email.", context);
            break;
          case "wrong-password":
            Utils.flushBarErrorMessage("Wrong password provided.", context);
            break; // Display an appropriate error message to the user
          default:
            print('Error during registration: ${e.message}');
        }
      } else {
        print('Error during login: $e');
      }
    }
  }

  register(BuildContext context) async {
    try {
      setLoading(true);
      final res = await auth.createUserWithEmailAndPassword(
          email: email.value.text, password: password.value.text);
      if (res.additionalUserInfo!.profile != null) {
        success(res.user!.uid, res.user!, true);
      }
      setLoading(false);
      Utils.snackBar("SignUp successfully", context);
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        builder: (BuildContext context) {
          return const LoginScreen();
        },
      );
    } catch (e) {
      setLoading(false);
      if (e is FirebaseAuthException) {
        // Handle specific Firebase Auth exceptions
        switch (e.code) {
          case 'weak-password':
            Utils.flushBarErrorMessage(
                'The password provided is too weak.', context);
            // Display a user-friendly message or take appropriate action
            break;
          case 'wrong password':
            Utils.flushBarErrorMessage(
                'Wrong email/password combination.', context);

            break;
          case 'email-already-in-use':
            Utils.flushBarErrorMessage(
                "The account already exists for that email.", context);
            // Display a user-friendly message or take appropriate action
            break;
          case 'invalid-email':
            Utils.flushBarErrorMessage(
                "The email address is not valid.", context);
            // Display a user-friendly message or take appropriate action
            break;
          case 'operation-not-allowed':
            Utils.flushBarErrorMessage(
                "Email/password accounts are not enabled.", context);
            // Display a user-friendly message or take appropriate action
            break;
          // Add more cases as needed for other error codes
          default:
            print('Error during registration: ${e.message}');
          // Display a generic error message or take appropriate action
        }
      } else {
        // Handle non-Firebase Auth exceptions
        print('Error during registration: $e');
        // Display a generic error message or take appropriate action
      }
    }
  }

  success(String uid, User user, isEmailRegistation) async {
    final isOldUser = isUserExists(uid);
    // ignore: unnecessary_null_comparison
    if (isOldUser != null) {
      await firestore.collection('users').doc(uid).set({
        'email': isEmailRegistation ? email.value.text.trim() : user.email,
        'uid': uid,
      });
    }

    Get.offAll(() => CourseScreen());
  }

  Future<bool> isUserExists(String uid) async {
    final user = await firestore.collection('users').doc(uid).get();
    return user.exists;
  }
}
