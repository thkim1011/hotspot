from app import app
from flask import send_file

from app.heatmap import save_heatmap

@app.route('/')
@app.route('/index')
def index():
    #save_heatmap()
    return send_file('images/heatmap.png', mimetype='image/gif')
