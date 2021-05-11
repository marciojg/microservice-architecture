FROM ruby:2.7.0

RUN apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /order_service

COPY Gemfile* /order_service/

RUN bundle install

COPY . /order_service

EXPOSE 3000

CMD [ "bundle", "exec", "rails", "-p", "3000" ]
