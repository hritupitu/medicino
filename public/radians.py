import firebase admin
from firebase_admin import credentials
from firebase_admin import firestore 
db = firestore.client()
id = []
docs=[]
collections = []
f=[]


def func(li , latitude ,longitude):
    docs.append(db.collection(u'pharmacies').stream()) # To access all docs in pharmacies collection 
    
    cnt=0
    for doc in docs:
        collections = db.collection('pharmacies').document(doc).collections() # Accessing meds subcollection
        #for collection in collections:
        for d in collections.stream():  #To access each doc of the meds collection
            for x in li: # To check if a particular med of li[x] is present in stock in a document of meds subcollection
                d = d.get()
                if(d.to_dict(x)): #check if required meds is present in the doc
                    if(d.to_dict('avail') > 1): # check if that particular med is in stock
                        cnt++
            if(cnt==5):
                id.append(doc)# if all 5 mediciines present then add document id
    
    
    for i in id:
        latp = i.to_dict('Lat')
        longp = i.to_dict('Long')
        latu = latu * (3.14/180)
        longu = longu * (3.14/180)
        lat = lat * (3.14 / 180)
        longi = longi * (3.14/180)
        c = math.cos(latp) * math.cos(latu) * maath.cos(lonp - lonu) + math.sin(latp)*math.sin(latu)
        c = min(c,1)
        c= max(c,1)
        psi = math.acos(c) 
        fin =  60.0405 * psi * (180.0/3.14)
        f.append(fin)
    f.sort()
    return f[:5]

        

                    







