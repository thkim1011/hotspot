import numpy as np
from scipy.stats import gaussian_kde
import matplotlib.pyplot as plt

import firebase_admin
from firebase_admin import credentials, db
from app.retreiver import Retreiver

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

    X, Y = np.mgrid[-5:5:200j, -5:5:200j]
    positions = np.vstack([X.ravel(), Y.ravel()])
    kernel = gaussian_kde(data, bw_method=bw)
    return np.reshape(kernel(positions).T, X.shape)

def gen_heatmap(bw=.8):
    # generate and show heatmap

    data = ret_to_data(ret)
    data = data_to_dist(data)

    heatmap = kde(data, bw=bw)
    plt.imshow(heatmap, cmap="inferno")
    plt.show()

def save_heatmap(bw=.8, filename="app/images/heatmap.png"):
    # Generate image and save to server's images/directory

    if ret.x is None:
        print('No data, stopping... Retreiving data...')
        ret.update_data()
        return

    if len(ret.x) < 5:
        print('Too little data... Retreiving data...')
        ret.update_data()
        return

    data = ret_to_data(ret)
    data = data_to_dist(data)

    # No borders
    fig = plt.figure(frameon=False)
    fig.set_size_inches(5,5)

    ax = plt.Axes(fig, [0., 0., 1., 1.])
    ax.set_axis_off()
    fig.add_axes(ax)

    heatmap = kde(data, bw=bw)

    x = np.linspace(-5, 5, 200)
    y = np.linspace(-5, 5, 200)
    X, Y = np.meshgrid(x, y)

    ax.imshow(heatmap, extent=(-5,5,5,-5), cmap='inferno')
    ax.contour(X, Y, heatmap, cmap="bone")

    ax.scatter(data[1,-1], data[0,-1], s=8, marker='*')
    fig.savefig(filename)
    plt.close()

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
        save(mru, filename='images/'+str(i)+'.png')
