from flask import Flask, render_template
import os

app = Flask(__name__)


@app.route("/")
def hello(name="Equal Experts"):
    return render_template("hello.html", name=name)


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(debug=True, host="0.0.0.0", port=port)
