FROM ruby:2.7.0

RUN apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /product_service

COPY Gemfile* /product_service/

RUN bundle install

COPY . /product_service

EXPOSE 3000

CMD [ "bundle", "exec", "rails", "-b", "0.0.0.0", "-p", "3000" ]