from flask import Flask, render_template, send_from_directory
import os

template_dir = '../build/web'
static_dir = '../build/web'
app = Flask(__name__, template_folder=template_dir, static_folder=static_dir)

@app.route("/")
def return_html():
    return render_template('index.html')

@app.route("/<path:name>")
def return_static(name):
    pathname = name
    print(pathname[0:13])
    if pathname[0:13] == 'assets/images':
        pathname = 'assets/' + pathname
    return send_from_directory('../build/web', pathname)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050)