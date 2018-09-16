import numpy as np

def compute_linear_pos(accel, time):
    """
    Given acceleration data accel and time,
    compute the relative position at each time.
    Takes in lists of length n and outputs pos list
    of length n + 1.
    """
    accel = np.array(accel)
    time = np.array(time)
    return np.cumsum(0.5 * accel * time**2)

def compute_positions(accel_x, accel_y, time):
    """
    Given acceleration data accel_x and accel_y,
    compute the relative positions of the "particle".
    In addition use signal processing to smooth out. 
    """
    return compute_linear_pos(accel_x, time), compute_linear_pos(accel_y, time)

def calibrate_gps(pos_x, pos_y, gps_x, gps_y, time):
    """
    Given relative positions and gps data at each point
    compute the best initial position which fits the data.
    """
    # Compute initial position
    pos_x = np.array(pos_x)
    pos_y = np.array(pos_y)
    gps_x = np.array(gps_x)
    gps_y = np.array(gps_y)
    initial = (np.sum(gps_x - pos_x)/len(gps_x),
            np.sum(gps_y - pos_y)/len(gps_y))
    return pos_x + initial[0], pos_y + initial[1]

