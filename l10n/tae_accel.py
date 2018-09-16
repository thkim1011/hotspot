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

data = ref.get()['thk_accel']
data = [list(val.values()) for val in data.values()]
data = np.array(data)

ax = data[:, 0]
ay = data[:, 1]

# filter
N = len(ax)
sigma = 3
dx = 1
gx = np.arange(-3*sigma, 3*sigma, dx)
gaussian = np.exp(-(gx/sigma)**2/2)
gaussian = gaussian / np.sum(gaussian)
fax = np.convolve(ax, gaussian, mode="full")
fay = np.convolve(ay, gaussian, mode="full")

#plt.plot(result)
#plt.plot(ax)
#plt.show()

dx = .5 * fax * .01**2
dy = .5 * fay * .01**2

x = np.cumsum(dx)
y = np.cumsum(dy)
