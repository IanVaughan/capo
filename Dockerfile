FROM ruby:2.3.0

MAINTAINER Ian Vaughan <ianrvaughan@gmail.com>

ENV APP_HOME /app

RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

# Add gemfile for bundle stage
ADD Gemfile* $APP_HOME/
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5

ADD . $APP_HOME

EXPOSE 80

ARG GIT_REVISION
ENV GIT_REVISION ${GIT_REVISION:-not set}

CMD ["rackup", "--host", "0.0.0.0"]
