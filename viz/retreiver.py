# Predict location given angle and displacement

import numpy as np
import matplotlib.pyplot as plt
import firebase_admin
from firebase_admin import credentials, db

class Retreiver():
    def __init__(self):
        self.read = set()
        self.x = None
        self.y = None
        self.strength = None
        self.time = None
        self.cred = credentials.Certificate('../secrets/clean-sylph-151200-ac19c9e9e196.json')

        firebase_admin.initialize_app(self.cred, {
            'databaseURL' : 'https://clean-sylph-151200.firebaseio.com'
        })

    def update_data(self):
        # Get from Realtime Database
        #default_app = firebase_admin.initialize_app(cred)

        ref = db.reference()

        data = ref.get()['datapoints']
        vals = data.values()
        data = [list(val.values()) for val in vals]
        data = np.array(data)

        dm = data[:, 0].astype(float)
        ang = data[:, 1].astype(float)
        self.strength = data[:, 3].astype(float)
        self.time = data[:, 4].astype(float)

        dx = np.multiply(dm, np.cos(ang / 180. * 3.151492))
        dy = np.multiply(dm, np.sin(ang / 180. * 3.151492))
         
        self.x = np.cumsum(dx)
        self.y = np.cumsum(dy)

    def get_mru(self):
        stack = np.vstack([self.x, self.y, self.strength, self.time])
        stack = stack[:, stack[3].argsort()]
        print(stack.shape)
        return stack[:,-100:]

#a = Retreiver()
#a.update_data()
#s = a.get_mru()
