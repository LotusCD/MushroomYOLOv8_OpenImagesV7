from flask import Flask, render_template, request, redirect, url_for
import os
import sys

# Add the directory containing predict.py to sys.path
sys.path.append('./')  # Adjust this path based on your setup

from predict import predict_image
from helpers.cleaner import clear_folder

app = Flask(__name__)
UPLOAD_FOLDER = './static/uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        if 'file' not in request.files:
            return redirect(request.url)
        file = request.files['file']
        if file.filename == '':
            return redirect(request.url)
        if file:
            clear_folder(app.config['UPLOAD_FOLDER'])
            filename = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
            file.save(filename)
            predictions = predict_image(filename)
            uploaded_filename = os.path.basename(filename)
            return render_template('index.html', uploaded_filename=uploaded_filename, predictions=predictions)
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
