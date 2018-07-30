FROM selenium/standalone-chrome
RUN sudo apt-get update && sudo apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get update && sudo apt-get install -y nodejs && sudo npm install -g @angular/cli
