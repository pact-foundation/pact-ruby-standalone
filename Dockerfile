FROM ruby:2.2

WORKDIR /opt

COPY install.sh .

RUN bash install.sh \
  && rm /opt/pact/lib/vendor/Gemfile.lock \
  && bundle install --gemfile /opt/pact/lib/vendor/Gemfile \
  && chmod og-w /usr/local/bundle /usr/local/bundle/bin

WORKDIR /opt/pact/bin

CMD ["/bin/bash"]
