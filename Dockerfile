FROM ruby:2.6.0

# Setup for current nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Setup for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install -j "$(expr "$(getconf _NPROCESSORS_ONLN)" - 1)"
COPY package.json yarn.lock ./
RUN yarn install

# Play with these if you want, remember to `make build` after
ENV SITE_TITLE "Splits I/O (Local)"
ENV READ_ONLY_MODE 0
ENV ENABLE_ADS 0

# Nothing below should ever need to be changed
ENV RAILS_ENV development
ENV NODE_ENV development

ENV RAILS_ROOT /app

ENV S3_BUCKET splits-io
ENV AWS_REGION local
ENV AWS_ACCESS_KEY_ID beep
ENV AWS_SECRET_KEY boop

COPY . /app
EXPOSE 3000
