FROM node:18.6.0

RUN apt update
RUN apt install -y pip python3-venv
RUN npm install -g aws-cdk
