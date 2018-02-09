FROM ruby:2.4.2

# Setup for current nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Setup for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Fill in your Twitch client information if you want login/signup to work
# You can make a Twitch client at https://dev.twitch.tv/dashboard/apps
ENV TWITCH_CLIENT_ID put_your_client_id_here
ENV TWITCH_CLIENT_SECRET put_your_client_secret_here

# Play with these if you want
ENV READ_ONLY_MODE 0
ENV ENABLE_ADS 0

# Nothing below should ever need to be changed
ENV RAILS_ENV development
ENV NODE_ENV development

ENV S3_BUCKET splits-io
ENV AWS_REGION local
ENV AWS_ACCESS_KEY_ID beep
ENV AWS_SECRET_KEY boop

ADD . /app
EXPOSE 3000
