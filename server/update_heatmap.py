from app.heatmap import save_heatmap
import time

i = 0

while True:
    print('Updating #{} ...'.format(i))
    save_heatmap()
    time.sleep(1)
    i += 1
