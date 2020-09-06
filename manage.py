import os
import unittest

from flask_migrate import Migrate, MigrateCommand
from flask_script import Manager

from app.main import create_app, db
from app.main.model import user
from app import blueprint
from app.main.model import blacklist

from flask_cors import CORS

app = create_app(os.getenv('CITYDB_ENV') or 'dev')

app.app_context().push()

manager = Manager(app)

migrate = Migrate(app, db)

manager.add_command('db', MigrateCommand)

app = create_app(os.getenv('CITYDB_ENV') or 'dev')
app.register_blueprint(blueprint)

app.app_context().push()

# enable CORS
#CORS(app, resources={r'/*': {'origins': '*'}})
#CORS(app)
#CORS(app, origins="http://localhost:8000")
#, allow_headers=[
#    "Content-Type", "Authorization", "Access-Control-Allow-Credentials"],
#    supports_credentials=True)

cors = CORS(app, resources={r"*": {"origins": "*"}})
#print(cors)

@manager.command
def run():
    app.run(host='0.0.0.0', port=8001)


@manager.command
def test():
    """Runs the unit tests."""
    tests = unittest.TestLoader().discover('app/test', pattern='test*.py')
    result = unittest.TextTestRunner(verbosity=2).run(tests)
    if result.wasSuccessful():
        return 0
    return 1

if __name__ == '__main__':
    manager.run()