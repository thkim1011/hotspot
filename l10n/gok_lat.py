import numpy as np
import matplotlib.pyplot as plt
import firebase_admin
from firebase_admin import credentials, db

# Get from Realtime Database
cred = credentials.Certificate('../secrets/clean-sylph-151200-ac19c9e9e196.json')
#default_app = firebase_admin.initialize_app(cred)

firebase_admin.initialize_app(cred, {
    'databaseURL' : 'https://clean-sylph-151200.firebaseio.com'
})

ref = db.reference()

data = ref.get()['datapoints']
vals = data.values()
data = [list(val.values()) for val in vals]
data = np.array(data)

lat = data[:, 1].astype(float)
lon = data[:, 2].astype(float)

lat = (lat - np.mean(lat)) / np.std(lat)
lon = (lon - np.mean(lon)) / np.std(lon)
