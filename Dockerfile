FROM centos:7.5.1804
MAINTAINER bradojevic@gmail.com

# install common tools
RUN yum install -y epel-release
RUN yum install -y which net-tools curl wget vim git
RUN yum install -y python36

# install pip
RUN curl -fsSL https://bootstrap.pypa.io/get-pip.py | python36 -
RUN pip3 install --upgrade pip

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV GUNICORN_VERSION 19.9.0
ENV FLASK_VERSION 1.0.2
ENV FLASK_CORS_VERSION 3.0.7
ENV PYTHONDONTWRITEBYTECODE true
ENV APP_ROOT /opt/app
# Create working dir
RUN mkdir -p ${APP_ROOT}

# install gunicorn & flask
RUN pip install gunicorn==${GUNICORN_VERSION}
RUN pip install flask==${FLASK_VERSION}
RUN pip install flask-cors==${FLASK_CORS_VERSION}

# install all project defined dependencies
COPY ./requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

WORKDIR ${APP_ROOT}
VOLUME ${APP_ROOT}

EXPOSE 8000

CMD /usr/local/bin/gunicorn --config=${APP_ROOT}/gunicorn/gunicorn_config.py src.app:app
