# Predict location given angle and displacement

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

dm = data[:, 0].astype(float)
ang = data[:, 1].astype(float)
strength = data[:, 3].astype(float)

dx = np.multiply(dm, np.cos(ang / 180. * 3.151492))
dy = np.multiply(dm, np.sin(ang / 180. * 3.151492))
 
x = np.cumsum(dx)
y = np.cumsum(dy)
