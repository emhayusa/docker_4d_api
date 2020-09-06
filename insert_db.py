#create db
from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database

from app.main.config import DB_URL_DEV
#DB_URL_DEV = 'postgresql://{user}:{pw}@{url}/{db}'.format(user=POSTGRES_USER,pw=POSTGRES_PW,url=POSTGRES_URL,db=POSTGRES_DB_DEV)
print(DB_URL_DEV)

engine = create_engine(DB_URL_DEV)

with engine.connect() as con:
    rs = con.execute("insert into area (id, area_name) values (1, 'Bandung'), (2, 'Jakarta Barat'), (3, 'Jakarta Pusat'), (4, 'Jakarta Selatan'), (5, 'Jakarta Timur'), (6, 'Jakarta Utara');")
    print(rs)
    rs = con.execute("insert into public.type(id, type_name) values (1, 'Contributor Attribute'), (2,'Contributor Geometry'),(3, 'Validator');")
    print(rs)
    rs = con.execute("insert into status(id, status_name) values (1, 'Waiting Approval'), (2,'Rejected'),(3, 'Approved');")
    print(rs)