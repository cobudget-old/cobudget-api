FROM ruby:2.2.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /cobudget-api
WORKDIR /cobudget-api
ADD Gemfile /cobudget-api/Gemfile
ADD Gemfile.lock /cobudget-api/Gemfile.lock
ENV RAILS_ENV development
RUN bundle install
ADD . /cobudget-api
