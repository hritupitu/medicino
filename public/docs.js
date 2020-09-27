const docList = document.querySelector('#doc-list');
const form = document.querySelector('#add-doc-form');
var lati;
var longi;

function renderPharm(doc){
    let li = document.createElement('li');
    let name = document.createElement('span');
    let spec = document.createElement('span');
    let loc = document.createElement('span');
    let contact = document.createElement('span');
    let clinic = document.createElement('span');

    li.setAttribute('data-id',doc.id);
    name.textContent = doc.data().name;
    loc.textContent = doc.data().location;
    spec.textContent = doc.data().specialization;
    contact.textContent = doc.data().contact;
    clinic.textContent = doc.data().clinic;

    li.appendChild(name);
    li.appendChild(loc);
    li.appendChild(spec);
    li.appendChild(contact);
    li.appendChild(clinic);

    docList.appendChild(li);
}

// db.collection('doctors').get().then((snapshot) => {
//     snapshot.docs.forEach(doc => {
//         renderPharm(doc);
//     });
// })

form.addEventListener('submit', (e) => {
    e.preventDefault();
    db.collection('doctors').add({
        name: form.name.value,
        location: new firebase.firestore.GeoPoint(parseFloat(form.latitude.value), parseFloat(form.longitude.value)),
        latitude: parseFloat(form.latitude.value),
        longitude: parseFloat(form.longitude.value),
        specialization: form.specialization.value,
        contact: parseInt(form.contact.value),
        clinic: form.clinic.value,
    })
    form.name.value = '';
    form.latitude.value = '';
    form.longitude.value = '';
    form.specialization.value ='';
    form.contact.value = '';
    form.clinic.value='';
    
    

})


//Real Time Listening

// db.collection('doctors').onSnapshot(snapshot => {
//     let changes = snapshot.docChanges();
//     changes.forEach(change => {
//         if(change.type=='added')
//         {
//             renderPharm(change.doc);
//         }
//     })
    
// })