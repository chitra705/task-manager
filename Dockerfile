# syntax=docker/dockerfile:1

# Ruby version
ARG RUBY_VERSION=3.0.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /rails

# Production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# -----------------------------
# Build stage
# -----------------------------
FROM base as build

# Fix Buster repo + install build dependencies
RUN sed -i 's|deb.debian.org|ftp.debian.org|g' /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy Gemfile first to leverage caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code
RUN bundle exec bootsnap precompile app/ lib/

# Precompile Rails assets (without RAILS_MASTER_KEY)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# -----------------------------
# Final runtime stage
# -----------------------------
FROM base

# Install runtime dependencies
RUN sed -i 's|deb.debian.org|ftp.debian.org|g' /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libvips && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy built gems & app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run as non-root user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint for DB prep
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose Rails port
EXPOSE 3000

# Default CMD
CMD ["./bin/rails", "server"]
