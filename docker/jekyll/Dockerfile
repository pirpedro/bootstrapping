FROM ruby:2.7-alpine
LABEL maintainer="Pedro Rodrigues <pir.pedro@gmail.com>"

RUN apk add --no-cache build-base gcc bash cmake

RUN gem install bundler -v "~>1.0" && gem install bundler jekyll

EXPOSE 4000

WORKDIR /site

ENTRYPOINT ["jekyll"]

CMD ["--help"]