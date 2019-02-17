FROM python:3.7-alpine

RUN apk --update --no-cache --virtual=build-dependencies add \
        build-base python3-dev \libxml2-dev libxslt-dev postgresql-dev  && \
    apk --update --no-cache add libstdc++ libpq && \
    apk --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --update add leveldb leveldb-dev    
RUN pip install dataflows gunicorn aiohttp
RUN pip install dgp==0.0.2

ADD requirements.txt /dgp/
RUN pip install -r /dgp/requirements.txt
RUN mkdir -p /var/datapip.es

ADD . /dgp/

EXPOSE 8000
WORKDIR /dgp/

CMD gunicorn --bind 0.0.0.0:8000 server.server:app --worker-class aiohttp.GunicornWebWorker

