FROM ruby:2.6.0

# Setup for current nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

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

COPY . /app
EXPOSE 3000
