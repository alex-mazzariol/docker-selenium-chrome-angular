FROM selenium/standalone-chrome
USER root
RUN apt-get update && apt-get install -y curl && apt-get clean
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get update && apt-get install -y nodejs && apt-get clean && npm install -g @angular/cli
