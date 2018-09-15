from app import app
from flask import send_file

@app.route('/')
@app.route('/index')
def index():
    return send_file('images/heatmap.png', mimetype='image/gif')
    #return "Hello, World!"
