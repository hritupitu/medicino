import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon_app/models/doctor.dart';
import 'package:hackathon_app/models/user.dart';
import 'package:hackathon_app/notifier/user_notifier.dart';

final firestoreInstance = FirebaseFirestore.instance;

getUserFromFirestore(User firebaseUser, UserNotifier userNotifier) async {
  DocumentSnapshot userDoc =
      await firestoreInstance.collection("User").doc(firebaseUser.uid).get();
  CustomUser user = CustomUser.fromJson(userDoc.data());
  userNotifier.setUser(user);
}

createUserInFirestore(User user, String gender) async {
  firestoreInstance.collection("User").doc(user.uid).set({
    "name": user.displayName,
    "email": user.email,
    "gender": gender,
  });
}

getDoctorsFromFirestore() async {
  QuerySnapshot docList = await firestoreInstance
      .collection("doctors")
      .get()
      .catchError((e) => print(" error" + e));

  Map<int, Doctor> docData = {};
  docList.docs.asMap().forEach((key, value) {
    Doctor doc = Doctor.fromJson(value.data());
    docData[key] = doc;
    // docData[key].location = doc.location;
  });

  return docData;
}

getDiseases(List<String> symptomList) async {
  var diseaseList = [];
  QuerySnapshot docList = await firestoreInstance
      .collection("diseases")
      .where("symptoms", arrayContainsAny: symptomList)
      .get();
  docList.docs.forEach((element) {
    print(element.data());
    diseaseList.add(element.data());
  });

  return diseaseList;
}
