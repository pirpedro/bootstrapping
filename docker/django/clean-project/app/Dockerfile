FROM python:3.8.3-alpine3.11
LABEL maintainer="Pedro Rodrigues <pir.pedro@gmail.com>"
WORKDIR /usr/src/app

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN pip install --upgrade pip
COPY ./requirements.txt /usr/src/app/requirements.txt

RUN apk add --no-cache --virtual .build-deps \
  build-base postgresql-dev  \
    && pip install -r requirements.txt \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
    && apk add --virtual .rundeps $runDeps \
    && apk del .build-deps

COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
COPY . /usr/src/app/

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]