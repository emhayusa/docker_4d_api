#!/bin/sh

python /opt/code/create_db.py
python /opt/code/manage.py db init
python /opt/code/manage.py db migrate
python /opt/code/manage.py db upgrade