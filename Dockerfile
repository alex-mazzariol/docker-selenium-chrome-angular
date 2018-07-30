FROM selenium/standalone-chrome
RUN sudo apt-get update && sudo apt-get install -y curl && sudo apt-get clean
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get update && sudo apt-get install -y nodejs && sudo apt-get clean && sudo npm install -g @angular/cli
