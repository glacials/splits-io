FROM ruby:2.3.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Fill in your Twitch client information if you want login/signup to work
# You can make a Twitch client at https://dev.twitch.tv/dashboard/apps
ENV TWITCH_CLIENT_ID put_your_client_id_here
ENV TWITCH_CLIENT_SECRET put_your_client_secret_hete

# Play with these if you want
ENV READ_ONLY_MODE 0
ENV ENABLE_ADS 0

# Nothing below should ever need to be changed
ENV RAILS_ENV development

ENV S3_BUCKET splits-io
ENV AWS_REGION local
ENV AWS_ACCESS_KEY_ID beep
ENV AWS_SECRET_KEY boop

ADD . /app
EXPOSE 3000
