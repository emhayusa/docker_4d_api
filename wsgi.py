import os

from app.main import create_app
from app import blueprint
from flask_cors import CORS

app = create_app(os.getenv('CITYDB_ENV') or 'dev')

app.register_blueprint(blueprint)
cors = CORS(app, resources={r"*": {"origins": "*"}})

