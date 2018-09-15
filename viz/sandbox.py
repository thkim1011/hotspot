import numpy as np
from scipy.stats import gaussian_kde
import matplotlib.pyplot as plt

def dist(n):
    return np.random.randn(2, n)

def kde(data):
    X, Y = np.mgrid[-3:3:100j, -3:3:100j]
    positions = np.vstack([X.ravel(), Y.ravel()])
    kernel = gaussian_kde(data)
    return np.reshape(kernel(positions).T, X.shape)

def gen_data(f):
    X = np.arange(-5, 5, 0.25)
    Y = np.arange(-5, 5, 0.25)
    X, Y = np.meshgrid(X, Y)

    Z = f(X, Y)

    return Z

def gen_heatmap(data):
    heatmap = kde(data)
    plt.imshow(heatmap, cmap="inferno")
    plt.show()
