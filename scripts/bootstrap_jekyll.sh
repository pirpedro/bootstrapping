#!/usr/bin/env bash

JEKYLL_VERSION=4.0
docker run --rm -v "$PWD":/srv/jekyll jekyll/jekyll:$JEKYLL_VERSION jekyll new .
#docker run --rm -v "$PWD":/srv/jekyll -v "$PWD"/vendor/bundle:/usr/local/bundle jekyll/jekyll:$JEKYLL_VERSION jekyll new .