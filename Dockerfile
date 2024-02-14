ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG $BUNDLE_PATH
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV GEM_HOME /bundle
ENV LANG C.UTF-8
ENV NODE_MAJOR=20
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

RUN sudo apt install
RUN wget https://dl.yarnpkg.com/debian/pubkey.gpg
RUN sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
RUN sudo apt-get update && sudo apt-get install libpq-dev nodejs postgresql-contrib -y
RUN cat pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn libvips-dev
RUN bundle config set force_ruby_platform true

RUN gem update --system

RUN mkdir -p /app
WORKDIR /app
