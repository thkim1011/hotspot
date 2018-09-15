import numpy as np
from scipy.stats import gaussian_kde
import matplotlib.pyplot as plt

import firebase_admin
from firebase_admin import credentials, db

def get_data():
    # Get from Realtime Database
    cred = credentials.Certificate('../secrets/clean-sylph-151200-ac19c9e9e196.json')
    #default_app = firebase_admin.initialize_app(cred)

    firebase_admin.initialize_app(cred, {
            'databaseURL' : 'https://clean-sylph-151200.firebaseio.com'
            })

    ref = db.reference()

    data = ref.get()

    data = [datum.split(',') for datum in data if datum is not None]

    return np.array(data).astype(float)

RECENCY_SIZE = 100
mru = np.ones((2, RECENCY_SIZE))
mru_ptr = 0

def update_mru(data):
    global mru_ptr

    mru[:, mru_ptr] = data
    mru_ptr = (mru_ptr + 1) % mru.shape[1]

def dist(n):
    # Generate random data from normal distribution, n points

    return np.random.randn(2, n)

def kde(data):
    # Run kde on set of 2-d points

    X, Y = np.mgrid[-3:3:100j, -3:3:100j]
    positions = np.vstack([X.ravel(), Y.ravel()])
    kernel = gaussian_kde(data)
    return np.reshape(kernel(positions).T, X.shape)

def gen_heatmap(data):
    # generate and show heatmap

    heatmap = kde(data)
    plt.imshow(heatmap, cmap="inferno")
    plt.show()

def save(data=dist(100), filename="../server/app/images/heatmap.png"):
    # Generate image and save to server's images/directory

    # No borders
    fig = plt.figure(frameon=False)
    fig.set_size_inches(5,5)

    ax = plt.Axes(fig, [0., 0., 1., 1.])
    ax.set_axis_off()
    fig.add_axes(ax)

    heatmap = kde(data)

    ax.imshow(heatmap, cmap='inferno')
    fig.savefig(filename)

if False:
    # Generate random data and save video of heatmap
    for i in range(200):
        rand_pt = np.random.randn(2)
        update_mru(rand_pt)
        print(i)
        save(mru, filename='images/'+str(i)+'.png')

