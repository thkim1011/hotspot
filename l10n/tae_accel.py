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

data = ref.get()['thk_accel2']
data = [list(val.values()) for val in data.values()]
data = np.array(data)

ax = data[:, 0]
ay = data[:, 1]
t = data[:, 2] / 10e9

# filter
N = len(ax)
sigma = 3
dx = 1
gx = np.arange(-3*sigma, 3*sigma, dx)
gaussian = np.exp(-(gx/sigma)**2/2)
gaussian = gaussian / np.sum(gaussian)
fax = np.convolve(ax, gaussian, mode="full")
fay = np.convolve(ay, gaussian, mode="full")
fax = ax
fay = ay

#plt.plot(result)
#plt.plot(ax)
#plt.show()

#dx = .5 * np.multiply(fax[:-1], np.square(np.diff(t)))
#dy = .5 * np.multiply(fay[:-1], np.square(np.diff(t)))

#x = np.cumsum(dx)
#y = np.cumsum(dy)

dvx = np.multiply(fax[:-1], np.diff(t))
dvy = np.multiply(fay[:-1], np.diff(t))

vx = np.cumsum(dvx)
vy = np.cumsum(dvy)

dx = np.multiply(vx, np.diff(t))
dy = np.multiply(vy, np.diff(t))

x = np.cumsum(dx)
y = np.cumsum(dy)
