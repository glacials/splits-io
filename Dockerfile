FROM ruby:2.6.4-alpine

# Build base for gem's native extensions
# tzdata for ruby timezone data
# gcompat for ffi to load LSC
RUN apk update \
    && apk add -u --no-cache build-base tzdata gcompat git postgresql-dev bash nodejs yarn \
    && rm -rf /var/cache/apk/*

ENV LANG=C.UTF-8 \
    GEM_HOME=/bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin
# Add bundle dir to path to be able to access commands outside of `bundle exec`
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

RUN gem update --system

RUN mkdir /app
WORKDIR /app
