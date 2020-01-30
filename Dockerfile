ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION AS builder

# Install node/npm
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

# Install yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

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

COPY Gemfile* package.json yarn.lock ./

RUN bundle install -j "$(expr "$(getconf _NPROCESSORS_ONLN)" - 1)" --without development:test \
    && rm -rf $BUNDLE_PATH/cache/*.gem \
    && find $(bundle list --paths) -name "*.c" -delete \
    && find $(bundle list --paths) -name "*.o" -delete

RUN yarn install
COPY . .
ARG SPLITSIO_CLIENT_ID
ARG STRIPE_PUBLISHABLE_KEY
RUN DATABASE_URL=nulldb://host/db SECRET_KEY_BASE="$(bundle exec rails secret)" \
    REDIS_URL=redis://redis:6379/1 \
    SPLITSIO_CLIENT_ID=$SPLITSIO_CLIENT_ID STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY \
    bin/rails assets:precompile

RUN rm -rf node_modules/ tmp/cache vendor/assets spec

#############

FROM ruby:$RUBY_VERSION AS runtime

ENV LANG=C.UTF-8 \
    GEM_HOME=/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin
# Add bundle dir to path to be able to access commands outside of `bundle exec`
ENV PATH=/app/bin:$BUNDLE_BIN:$PATH

# Install node/npm
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

# Install yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

COPY --from=builder /app /app
COPY --from=builder /bundle /bundle

WORKDIR /app
