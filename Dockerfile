FROM node:18.19.1

RUN apt update
RUN apt install -y pip python3-venv
RUN apt install -y awscli
RUN npm install -g aws-cdk
