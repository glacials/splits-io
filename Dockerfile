# latest is just the default value,
# in practice this is always overridden by compose files.
ARG RUBY_VERSION=latest
FROM ruby:$RUBY_VERSION

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash

RUN wget https://dl.yarnpkg.com/debian/pubkey.gpg
RUN cat pubkey.gpg | apt-key add -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libvips-dev nodejs python3
RUN npm install --global yarn
RUN bundle config set force_ruby_platform true

RUN node -v

ENV LANG C.UTF-8
ENV GEM_HOME /bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG $BUNDLE_PATH
ENV BUNDLE_BIN $BUNDLE_PATH/bin
# Add bundle dir to path to be able to access commands outside of `bundle exec`
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

# RUN gem update --system

RUN mkdir -p /app
WORKDIR /app
