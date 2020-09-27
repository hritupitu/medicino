const medList = document.querySelector('#med-list');
const form = document.querySelector('#add-med-form');

function renderMed(doc){
    let li = document.createElement('li');
    let name = document.createElement('span');
    let price = document.createElement('span');
    let avail = document.createElement('span');

    li.setAttribute('data-id',doc.id);
    name.textContent = doc.data().name;
    price.textContent = doc.data().price;
    avail.textContent = doc.data().avail;

    li.appendChild(name);
    li.appendChild(price);
    li.appendChild(avail);

    medList.appendChild(li);
}

// db.collection('doctors').get().then((snapshot) => {
//     snapshot.docs.forEach(doc => {
//         renderPharm(doc);
//     });
// })

form.addEventListener('submit', (e) => {
    e.preventDefault();
    db.collection('pharmacies').collection('meds').add({
        name: form.name.value,
        avail: form.avail.value,
        price: form.price.value,
    })
    form.name.value = '';
    form.avail.value = '';
    form.price.value = '';
    
    

})


//Real Time Listening

db.collection('pharmacies').collection('meds').onSnapshot(snapshot => {
    let changes = snapshot.docChanges();
    changes.forEach(change => {
        if(change.type=='added')
        {
            renderMed(change.doc);
        }
    })
    
})