FROM --platform=linux/amd64 amazonlinux:2

ARG APP_ROOT='/usr/src/rails_tutorial'
ARG RUBY_VERSION='2.5.7'
ARG BUNDLER_VERSION='2.3.21'

ENV PATH="${PATH}:/opt/ruby-${RUBY_VERSION}/bin"

WORKDIR $APP_ROOT

# amazonlinux での locale 対応
RUN yum install -y glibc-langpack-ja
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.utf8

# install development tools(amazon linux)
RUN yum -y groupinstall "Development Tools"

# install Ruby
RUN yum install -y git gcc openssl openssl-devel readline-devel zlib-devel
RUN git clone https://github.com/rbenv/ruby-build.git /usr/local/ruby-build
RUN /usr/local/ruby-build/install.sh
RUN /usr/local/bin/ruby-build ${RUBY_VERSION} /opt/ruby-${RUBY_VERSION} --verbose
RUN gem install bundler --force -v ${BUNDLER_VERSION}

# install Node.js
RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash -
RUN yum install -y nodejs

# install mysql
RUN yum install -y mariadb-devel

# bundle install
COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT
RUN bundle install