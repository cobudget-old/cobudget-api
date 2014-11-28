FROM stackbrew/ruby:2.1

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev postgresql-contrib

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --full-index --jobs $(nproc)

ADD . /app
WORKDIR /app

CMD bundle exec rackup
