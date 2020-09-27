import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon_app/api/user_api.dart';
import 'package:hackathon_app/notifier/auth_notifier.dart';

login(String email, String password, AuthNotifier authNotifier) async {
  try {
    authNotifier.setLoading(true);
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) => handleErrors(error, authNotifier));
    if (authResult != null) {
      authNotifier.setError('');
      User firebaseUser = authResult.user;
      if (firebaseUser != null) {
        authNotifier.setUser(firebaseUser);

        authNotifier.setLoading(false);
      }
      authNotifier.setLoading(false);
    }
    authNotifier.setLoading(false);
  } on SocketException {
    authNotifier
        .setError('Please check your internet connection and try again.');
    authNotifier.setLoading(false);
  }
}

signUp(String email, String password, String name, String gender,
    AuthNotifier authNotifier) async {
  try {
    authNotifier.setLoading(true);
    UserCredential authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((error) => handleErrors(error, authNotifier));
    if (authResult != null) {
      authNotifier.setError('');

      User firebaseUser = authResult.user;
      if (firebaseUser != null) {
        await firebaseUser.updateProfile(displayName: name);
        await firebaseUser.reload();
        await firebaseUser.sendEmailVerification();
        User user = FirebaseAuth.instance.currentUser;
        await createUserInFirestore(user, gender);
        authNotifier.setLoading(false);
      }
      authNotifier.setLoading(false);
    }
    authNotifier.setLoading(false);
  } on SocketException {
    authNotifier
        .setError('Please check your internet connection and try again.');
    authNotifier.setLoading(false);
  }
}

googleSignIn(AuthNotifier authNotifier, String gender) async {
  try {
    authNotifier.setLoading(true);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User user = (await _auth.signInWithCredential(credential)).user;
    if (user != null) {
      await createUserInFirestore(user, gender);
    }
    authNotifier.setError('');
    authNotifier.setUser(user);
    authNotifier.setLoading(false);
  } on NoSuchMethodError {
    authNotifier.setError('');
    authNotifier.setLoading(false);
  } on SocketException {
    authNotifier
        .setError('Please check your internet connection and try again.');
    authNotifier.setLoading(false);
  } catch (e) {
    authNotifier.setLoading(false);
    handleErrors(e, authNotifier);
  }
}

signIn(AuthCredential authCredentials, AuthNotifier authNotifier,
    String gender) async {
  authNotifier.setLoading(true);
  UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(authCredentials);
  User user = authResult.user;
  await createUserInFirestore(user, gender);
  authNotifier.setUser(user);
  authNotifier.setError('');
  authNotifier.setLoading(false);
}

signOut(AuthNotifier authNotifier) async {
  authNotifier.setLoading(true);
  await FirebaseAuth.instance.signOut().catchError((err) => print(err.code));
  authNotifier.setUser(null);
  authNotifier.setLoading(false);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    authNotifier.setUser(currentUser);
  }
}

resendEmail() async {
  User currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    currentUser.sendEmailVerification();
  }
}

sendResetPasswordEmail(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

handleErrors(error, AuthNotifier authNotifier) {
  String errorMessage;
  switch (error.code) {
    case "ERROR_INVALID_EMAIL":
      errorMessage = "Your email address appears to be malformed.";
      break;
    case "ERROR_WRONG_PASSWORD":
      errorMessage = "Your password is incorrect.";
      break;
    case "ERROR_USER_NOT_FOUND":
      errorMessage = "User with this Email doesn't exist.";
      break;
    case "ERROR_USER_DISABLED":
      errorMessage = "User with this Email has been disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
      errorMessage = "Too many unsuccessful attempts. Try again later.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      errorMessage = "Signing in with Email and Password is not enabled.";
      break;
    case "ERROR_INVALID_VERIFICATION_CODE":
      errorMessage = "Incorrect OTP. Please try again";
      break;
    case "ERROR_SESSION_EXPIRED":
      errorMessage = "The OTP has expired. Try resending it again.";
      break;
    case "ERROR_EMAIL_ALREADY_IN_USE":
      errorMessage = error.message;
      break;
    case "ERROR_NETWORK_REQUEST_FAILED":
      errorMessage = error.message;
      break;
    case "network_error":
      errorMessage = "Please check your internet connection and try again.";
      break;
    default:
      errorMessage = error.message;
  }
  authNotifier.setError(errorMessage);
}

String handleForgotPasswordErrors(error) {
  String errorMessage;
  switch (error.code) {
    case "ERROR_INVALID_EMAIL":
      errorMessage = "Your email address appears to be malformed.";
      break;
    case "ERROR_WRONG_PASSWORD":
      errorMessage = "Your password is incorrect.";
      break;
    case "ERROR_USER_NOT_FOUND":
      errorMessage = "User with this Email doesn't exist.";
      break;
    case "ERROR_USER_DISABLED":
      errorMessage = "User with this Email has been disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
      errorMessage = "Too many requests. Try again later.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      errorMessage = "Signing in with Email and Password is not enabled.";
      break;
    case "ERROR_NETWORK_REQUEST_FAILED":
      errorMessage = error.message;
      break;
    default:
      errorMessage = "An undefined error occurred. Please try again later.";
  }
  return errorMessage;
}

Future<bool> checkEmailVerifiedFromFirebase(AuthNotifier authNotifier) async {
  authNotifier.setLoading(true);
  User currentUser = FirebaseAuth.instance.currentUser;
  currentUser.reload();
  User firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser.emailVerified) {
    authNotifier.setUser(firebaseUser);
  }
  authNotifier.setLoading(false);
  return firebaseUser.emailVerified;
}

deleteUser(AuthNotifier authNotifier) async {
  authNotifier.setLoading(true);
  User user = FirebaseAuth.instance.currentUser;
  await user.delete();
  authNotifier.setUser(null);
  authNotifier.setError('');
}
