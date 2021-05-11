FROM ruby:2.7.0

RUN apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /support_service

COPY Gemfile* /support_service/

RUN bundle install

COPY . /support_service

EXPOSE 3000

CMD [ "bundle", "exec", "rails", "-p", "3000" ]
