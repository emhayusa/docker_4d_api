#create db
from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database

from app.main.config import DB_URL_DEV
#DB_URL_DEV = 'postgresql://{user}:{pw}@{url}/{db}'.format(user=POSTGRES_USER,pw=POSTGRES_PW,url=POSTGRES_URL,db=POSTGRES_DB_DEV)
print(DB_URL_DEV)

engine = create_engine(DB_URL_DEV)
if not database_exists(engine.url):
    create_database(engine.url)

print(database_exists(engine.url))