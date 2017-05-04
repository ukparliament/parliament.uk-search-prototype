FROM ruby:2-alpine

# Add command line argument variables used to cusomise the image at build-time.
ARG OPENSEARCH_DESCRIPTION_URL
ARG GTM_KEY
ARG ASSET_LOCATION_URL
ARG RACK_ENV=production
ARG OPENSEARCH_AUTH_TOKEN
# Add Gemfiles.
ADD Gemfile /app/
ADD Gemfile.lock /app/

# Set the working DIR.
WORKDIR /app

# Install system and application dependencies.
RUN apk --update add --virtual build-dependencies build-base ruby-dev && \
    gem install bundler --no-ri --no-rdoc && \
    echo "Environment (RACK_ENV): $RACK_ENV" && \
    if [ "$RACK_ENV" == "production" ]; then \
      bundle install --without development test --path vendor/bundle; \
      apk del build-dependencies; \
    else \
      gem install rake --no-ri --no-rdoc; \
      bundle install --path vendor/bundle; \
    fi

# Copy the application onto our image.
ADD . /app

# Make sure our user owns the application directory.
RUN if [ "$RACK_ENV" == "production" ]; then \
      chown -R nobody:nogroup /app; \
    else \
      chown -R nobody:nogroup /app /usr/local/bundle; \
    fi

# Set up our user and environment
USER nobody
ENV OPENSEARCH_DESCRIPTION_URL $OPENSEARCH_DESCRIPTION_URL
ENV GTM_KEY $GTM_KEY
ENV ASSET_LOCATION_URL $ASSET_LOCATION_URL
ENV RACK_ENV $RACK_ENV
ENV OPENSEARCH_AUTH_TOKEN $OPENSEARCH_AUTH_TOKEN

# Add additional labels to our image
ARG GIT_SHA=unknown
ARG GIT_TAG=unknown
LABEL git-sha=$GIT_SHA \
	    git-tag=$GIT_TAG \
	    rack-env=$RACK_ENV \
	    maintainer=mattrayner1@gmail.com

# Launch puma
CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]