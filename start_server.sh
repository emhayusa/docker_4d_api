#!/bin/sh

#rm -r migrations
python /opt/code/create_db.py
python /opt/code/manage.py db init
python /opt/code/manage.py db migrate
python /opt/code/manage.py db upgrade
python /opt/code/insert_db.py

_term() {
  echo "Caught SIGTERM signal! Sending graceful stop to uWSGI through the master-fifo"
  # See details in the uwsgi.ini file and
  # in http://uwsgi-docs.readthedocs.io/en/latest/MasterFIFO.html
  # q means "graceful stop"
  echo q > /tmp/uwsgi-fifo
}

trap _term SIGTERM

uwsgi --ini /opt/uwsgi/uwsgi.ini &

# We need to wait to properly catch the signal, that's why uWSGI is started
# in the background. $! is the PID of uWSGI
wait $!
# The container exits with code 143, which means "exited because SIGTERM"
# 128 + 15 (SIGTERM)
# http://www.tldp.org/LDP/abs/html/exitcodes.html
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_12_02.html
