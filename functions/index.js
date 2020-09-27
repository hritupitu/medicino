const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// auth trigger (new user signup)
exports.newUserSignUp = functions.auth.user().onCreate(user => {
  // console.log('user created: ', user.email, user.uid);
  return admin.firestore().collection('pharmacies').doc(user.uid).set({
    email: user.email,
    // name: user.name,
    // latitude: parseFloat(user.latitude),
    // longitude: parseFloat(user.longitude),
  })
});

// auth trigger (user deleted)
exports.userDeleted = functions.auth.user().onDelete(user => {
  // console.log('user deleted: ', user.email, user.uid);
  const doc =  admin.firestore().collection('pharmacies').doc(user.uid);
    return doc.delete();
});