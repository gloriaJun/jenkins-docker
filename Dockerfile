# base image
FROM node:12.13.0-alpine as builder

RUN apt-get update && apt-get -y upgrade && apt-get install -y openjdk-8-jdkn

# ENV NPM_CONFIG_CACHE=/npm-cache \
#     YARN_CACHE_FOLDER=/yarn-cache \
#     CLEAN="$CLEAN:\$NPM_CONFIG_CACHE/:\$YARN_CACHE_FOLDER/:/usr/lib/node_modules/npm/doc:/usr/lib/node_modules/npm/man:/usr/lib/node_modules/npm/html"


# RUN apt-get update 