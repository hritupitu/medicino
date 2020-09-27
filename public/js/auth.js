const authSwitchLinks = document.querySelectorAll('.switch');
const authModals = document.querySelectorAll('.auth .modal');
const authWrapper = document.querySelector('.auth');
const registerForm = document.querySelector('.register');
const loginForm = document.querySelector('.login');
const signOut = document.querySelector('.sign-out');

// toggle auth modals
authSwitchLinks.forEach(link => {
  link.addEventListener('click', () => {
    authModals.forEach(modal => modal.classList.toggle('active'));
  });
});
// auth status
firebase.auth().onAuthStateChanged(user => {
    if(user) {
        console.log("User logged in: ", user);
        sessionStorage.currentUser = user.uid;
        sessionStorage.currentUserVerified = user.emailVerified;
        sessionStorage.currentUserEmail = user.email;
        toggleLinks(user);
        if(!user.emailVerified){
            emailVerificationNotification();
        }
    } else {
        console.log("User logged out");
        toggleLinks();
        sessionStorage.currentUser = '';
        sessionStorage.currentUserVerified = false;
        sessionStorage.currentUserEmail = '';
    }
})
// register form
registerForm.addEventListener('submit', (e) => {
  e.preventDefault();
  
  const email = registerForm.email.value;
  const password = registerForm.password.value;
  const name = registerForm.name.value;
  const latitude = registerForm.latitude.value;
  const longitude = registerForm.longitude.value;

  firebase.auth().createUserWithEmailAndPassword(email, password)
    .then(userData => {
      console.log('registered', userData);
      if(userData) {
      var user = firebase.auth().currentUser;
      user.updateProfile({
          displayName: name,
          // displayLat: latitude,
          // displayLong: longitude,
      })
      
          firebase.firestore().collection('pharmacies').doc(user.uid).add({
              name: user.displayName,
              latitude: latitude,
              longitude: longitude,
          })
          sendVerificationEmail(user);
          const modal = document.querySelector('#register');
          M.Modal.getInstance(modal).close();
          registerForm.reset();
          sidenavDissmiss();
          window.location.reload();
      }
      registerForm.reset();
    
    })
    .catch(error => {
      registerForm.querySelector('.error').textContent = error.message;
    });
});


// //New Regi
// registerForm.addEventListener('submit', (e) => {
//     e.preventDefault();
    
//     const email = registerForm.email.value;
//     const password = registerForm.password.value;
  
//     firebase.auth().createUserWithEmailAndPassword(email, password)
//       .then(user => {
//         console.log('registered', user);
//         registerForm.reset();
//       })
//       .catch(error => {
//         registerForm.querySelector('.error').textContent = error.message;
//       });
//   });

// login form
loginForm.addEventListener('submit', (e) => {
  e.preventDefault();
  
  const email = loginForm.email.value;
  const password = loginForm.password.value;

  firebase.auth().signInWithEmailAndPassword(email, password)
    .then(user => {
      console.log('logged in', user);
      loginForm.reset();
    })
    .catch(error => {
      loginForm.querySelector('.error').textContent = error.message;
    });
});

// sign out
signOut.addEventListener('click', () => {
  firebase.auth().signOut()
    .then(() => console.log('signed out'));
});

// auth listener
firebase.auth().onAuthStateChanged(user => {
  if (user) {
    authWrapper.classList.remove('open');
    authModals.forEach(modal => modal.classList.remove('active'));
  } else {
    authWrapper.classList.add('open');
    authModals[0].classList.add('active');
  }
});