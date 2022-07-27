#!/bin/bash

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

C_H1=${MAGENTA}
C_H2=${MAGENTA}
C_INFO=${BLUE}
C_VARNAME=${CYAN}
C_DATA=${YELLOW}

software_info() {

echo "

${C_H2}---------- conatiner info ----------${NORMAL}
"

echo "node: ${C_DATA}"
node --version
echo "${NORMAL}"

echo "cdk:  ${C_DATA}"
cdk --version
echo "${NORMAL}"

echo "python: ${C_DATA}"
python3 --version
echo "${NORMAL}"

echo "pip: ${C_DATA}"
pip --version
echo "${NORMAL}"

echo "aws: ${C_DATA}"
aws --version
echo "${NORMAL}"

}

echo "
${C_H1}################################################################################${NORMAL}
${C_H1}################################# SETUP SCRIPT #################################${NORMAL}
${C_H1}################################################################################${NORMAL}

Welcome to the static-site setup script!

I am triggered when you do not have a ~/configs.env file.

This usually happens the first time you use this project,
or you have recently removed ~/configs.env.

I will help you with 2 key setup tasks:
- Confirm or setup config variables in ~/configs.env
- Confirm or setup your AWS Profile for CLI access

You can always get back to this setup by running make _setup,
or removing configs.env

See README.md for more info.
"

read -p "Ready for setup? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo
else
  echo 'setup aborted - you can run `make _setup` at any time.'
  software_info
  exit
fi

echo "
${C_H2}---------- config (~/configs.env) ----------${NORMAL}

You should have a registered domain and Hosted zone in Route53.

You will need your 'domain name' and 'Route 53 Hosted zone ID' for a successful deployment.

You can update ~/configs.env manually at any time.
"

# setting up the config is the default use case
SETUP_CONFIGS_FILE=true

# check what we should do if the config file already has data in it
if [ -s ${PWD}/configs.env ]; then

  echo "${C_INFO}Setup has detetcted a config file with some data${NORMAL}"
  echo
  echo "cat ~/configs.env${C_DATA}"
  cat ${PWD}/configs.env
  echo "${NORMAL}"

  read -p "Do you want me to delete this config file? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "${C_INFO}deleting ~/configs.env${NORMAL}"
    rm ${PWD}/configs.env
  else
    echo "${C_INFO}skipping configs.env config${NORMAL}"
    echo
    SETUP_CONFIGS_FILE=false
  fi
else
  echo "${C_INFO}Setup did not find a config file ~/configs.env - I can help generate one for you!${NORMAL}"
fi

# if the user doesn't want to delete the config we should skip setting it at all
if [ "$SETUP_CONFIGS_FILE" = true ] ; then

  echo 
  read -p "Configure configs.env with real data? Select no to load dummy data (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo
    echo "${C_VARNAME}APP_UNIQUE_NAME${NORMAL} - Used as a prefix for the resource names when creating infrastructure (eg static-site)"
    echo "Enter the value for ${C_VARNAME}APP_UNIQUE_NAME${NORMAL}:"
    read APP_UNIQUE_NAME

    echo
    echo "${C_VARNAME}APP_DOMAIN${NORMAL} - A valid domain name (eg example.com)"
    echo "Enter the value for ${C_VARNAME}APP_DOMAIN${NORMAL}:"
    read APP_DOMAIN

    echo
    echo "${C_VARNAME}APP_HOSTED_ZONE_ID${NORMAL} - Existing AWS Route53 Hosted Zone ID for the domain (eg Z248xxxCT25)"
    echo "Enter the value for ${C_VARNAME}APP_HOSTED_ZONE_ID${NORMAL}:"
    read APP_HOSTED_ZONE_ID
  fi

  echo "${C_INFO}Creating the config file ~/configs.env${NORMAL}"

  echo "APP_UNIQUE_NAME=${APP_UNIQUE_NAME}" > ${PWD}/configs.env;
  echo "APP_DOMAIN=${APP_DOMAIN}" >> ${PWD}/configs.env;
  echo "APP_HOSTED_ZONE_ID=${APP_HOSTED_ZONE_ID}" >> ${PWD}/configs.env;

  echo
  echo "cat ~/configs.env${C_DATA}"
  cat ${PWD}/configs.env
  echo "${NORMAL}"

fi

echo "${H2}---------- aws profile (~/.aws) ----------${NORMAL}

${C_INFO}~/.aws has been mounted from your workstation.${NORMAL}
"

read -p "Set AWS Profile Name ${C_VARNAME}AWS_PROFILE_NAME${NORMAL} [${C_DATA}${AWS_PROFILE_NAME}${NORMAL}]: " AWS_PROFILE_NAME
AWS_PROFILE_NAME=${AWS_PROFILE_NAME:-static-site}
echo

echo "checking for aws profile ${C_INFO}${AWS_PROFILE_NAME}${NORMAL}."
echo

profile_status=$( (aws configure --profile ${AWS_PROFILE_NAME} list ) 2>&1 )
if [[ $profile_status = *'could not be found'* ]]; then 
  echo "profile ${C_DATA}${AWS_PROFILE_NAME}${NORMAL} has ${RED}NOT${NORMAL} been setup. Configure it now for deployments to AWS.";
  echo 'If you are not ready to setup your AWS profile you can run `make aws_configure` later.'
  echo

  echo 'The set of permissions that have been tested for this repo, for bootstrap and deploy commands, are:

- IAMFullAccess, AmazonSSMFullAccess, ecr:*
- AmazonS3FullAccess, CloudFrontFullAccess, AmazonRoute53FullAccess, AWSCloudFormationFullAccess'

  echo
  read -p "Do you want to configure AWS credentials now? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
      aws configure --profile ${AWS_PROFILE_NAME}

      echo
      echo "profile ${C_DATA}${AWS_PROFILE_NAME}${NORMAL} has been setup:";
      echo "${C_DATA}"
      aws configure --profile ${AWS_PROFILE_NAME} list
      echo "${NORMAL}"
  fi

else
  echo "profile ${C_DATA}${AWS_PROFILE_NAME}${NORMAL} has already been setup, go you!:";
  echo "${C_DATA}"
  aws configure --profile ${AWS_PROFILE_NAME} list
  echo "${NORMAL}"
fi



software_info



echo
echo "${C_H1}setup complete.${NORMAL}"
echo