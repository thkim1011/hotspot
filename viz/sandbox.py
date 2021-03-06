import numpy as np
from scipy.stats import gaussian_kde
import matplotlib.pyplot as plt

import firebase_admin
from firebase_admin import credentials, db
from retreiver import Retreiver

ret = Retreiver()

def ret_to_data(ret):
    ret.update_data()
    mru = ret.get_mru()

    # Normalize positions

    mru[0, :] = (mru[0, :] - np.mean(mru[0, :])) / np.std(mru[0, :])
    mru[1, :] = (mru[1, :] - np.mean(mru[1, :])) / np.std(mru[1, :])

    # Normalize strengths
    mru[2, :] = (mru[2, :] - np.min(mru[2, :]) + 1)
    mru[2, :] /= np.max(mru[2,:])
    mru[2, :] *= 10
    
    return mru

def data_to_dist(data):
    dist = []
    for i in range(data.shape[1]):
        datum = data[:, i]
        strength = datum[2]
        x = datum[0]
        y = datum[1]
        for j in range(int(strength)):
            dist.append([x, y])

    return np.array(dist).T

data = ret_to_data(ret)
data = data_to_dist(data)

RECENCY_SIZE = 100
mru = np.ones((2, RECENCY_SIZE))
mru_ptr = 0

def update_mru(data):
    global mru_ptr

    mru[:, mru_ptr] = data
    mru_ptr = (mru_ptr + 1) % mru.shape[1]

def dist(n):
    # Generate random data from normal distribution, n points
    strength = np.random.randint(1, 10, size=(1, n))
    strength = np.vstack([strength, strength])

    return np.multiply(np.random.randn(2, n), strength)

def kde(data, bw=None):
    # Run kde on set of 2-d points

    X, Y = np.mgrid[-5:5:100j, -5:5:100j]
    positions = np.vstack([X.ravel(), Y.ravel()])
    kernel = gaussian_kde(data, bw_method=bw)
    return np.reshape(kernel(positions).T, X.shape)

def gen_heatmap(data, bw=None):
    # generate and show heatmap

    heatmap = kde(data, bw=bw)
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

