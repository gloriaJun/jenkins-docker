# base image
# v12.22.1
FROM node:12-alpine as node

RUN apk update \
  && apk add --no-cache openjdk8 \
        vim

# ENV NPM_CONFIG_CACHE=/npm-cache \
#     YARN_CACHE_FOLDER=/yarn-cache \
#     CLEAN="$CLEAN:\$NPM_CONFIG_CACHE/:\$YARN_CACHE_FOLDER/:/usr/lib/node_modules/npm/doc:/usr/lib/node_modules/npm/man:/usr/lib/node_modules/npm/html"


