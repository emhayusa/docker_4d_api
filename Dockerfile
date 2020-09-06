########
# This image will compile the dependencies
# It will install compilers and other packages, that won't be carried
# over to the runtime image
########
FROM alpine:3.9 AS compile-image
# Add requirements for python and pip
RUN apk add --update python3

RUN mkdir -p /opt/code
RUN mkdir -p /opt/code/app
WORKDIR /opt/code
# Install dependencies
RUN apk add python3-dev build-base gcc linux-headers postgresql-dev libffi-dev
# Create a virtual environment for all the Python dependencies
RUN python3 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
RUN pip3 install --upgrade pip
# Install and compile uwsgi
RUN pip3 install uwsgi==2.0.18
# Install other dependencies
#COPY requirements.txt /opt/
RUN pip3 install flask_migrate
RUN pip3 install flask_script
RUN pip3 install flask_restplus
RUN pip3 install Werkzeug==0.16.1
RUN pip3 install flask_bcrypt
RUN pip3 install pyjwt
RUN pip3 install flask_cors
RUN pip3 install sqlalchemy_utils
RUN pip3 install psycopg2
#RUN pip3 install -r /opt/requirements.txt

########
# This image is the runtime, will copy the dependencies from the other
########
FROM alpine:3.9 AS runtime-image
# Install python
RUN apk add --update python3 curl libffi postgresql-libs
# Copy uWSGI configuration
RUN mkdir -p /opt/uwsgi
ADD uwsgi.ini /opt/uwsgi/
#ADD create_db.sh /opt/uwsgi/
ADD start_server.sh /opt/uwsgi/
# Create a user to run the service
RUN addgroup -S uwsgi
RUN adduser -H -D -S uwsgi
USER uwsgi
# Copy the venv with compile dependencies from the compile-image
COPY --chown=uwsgi:uwsgi --from=compile-image /opt/venv /opt/venv
# Be sure to activate the venv
ENV PATH="/opt/venv/bin:$PATH"
# Copy the code
COPY create_db.py /opt/code/
COPY manage.py /opt/code/
COPY insert_db.py /opt/code/
COPY --chown=uwsgi:uwsgi wsgi.py /opt/code/
# Run parameters
WORKDIR /opt/code
USER root

EXPOSE 8001
CMD ["/bin/sh", "/opt/uwsgi/start_server.sh"]