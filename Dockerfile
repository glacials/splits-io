ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

RUN wget https://dl.yarnpkg.com/debian/pubkey.gpg
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN cat pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn libvips-dev

ENV LANG C.UTF-8
ENV GEM_HOME /bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG $BUNDLE_PATH
ENV BUNDLE_BIN $BUNDLE_PATH/bin
# Add bundle dir to path to be able to access commands outside of `bundle exec`
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

RUN gem update --system

RUN mkdir -p /app
WORKDIR /app
