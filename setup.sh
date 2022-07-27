#!/bin/bash

software_info() {

echo '

---------- conatiner info ----------
'

echo "node: "
node --version
echo

echo "cdk: "
cdk --version
echo

python3 --version
pip --version
aws --version

echo

}

echo '
################################################################################

Welcome to the static-site setup script!

I am triggered when you do not have a ~/configs.env file.

This usually happens the first time you use this project,
or you have recently removed `~/configs.env`.

I will help you with 2 key setup tasks:
- setup of `~/configs.env`
- Confirm or setup your AWS Profile for CLI access

You can always get back to this setup by running `make _setup`,
or removing configs.env

See README.md for more info.
'

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
---------- config (~/configs.env) ----------

You should have a registered domain and Hosted zone in Route53.

You will need your 'domain name' and 'Route 53 Hosted zone ID' for a successful deployment.

You can update ~/configs.env manually at any time.
"

# setting up the config is the default use case
SETUP_CONFIGS_FILE=true

# check what we should do if the config file already has data in it
if [ -s ${PWD}/configs.env ]; then

  echo "Setup has detetcted a config file with some data"
  echo "cat ~/configs.env"
  echo
  cat ${PWD}/configs.env
  echo

  read -p "Do you want me to delete this config file? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "deleting ~/configs.env"
    rm ${PWD}/configs.env
  else
    echo "skipping configs.env config"
    SETUP_CONFIGS_FILE=false
  fi
else
  echo "Setup did not find a config file ~/configs.env - I can help generate one for you!"
fi

# if the user doesn't want to delete the config we should skip setting it at all
if [ "$SETUP_CONFIGS_FILE" = true ] ; then

  echo 
  read -p "Configure configs.env with real data? Select no to load dummy data (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo
    echo "APP_UNIQUE_NAME - Used as a prefix for the resource names when creating infrastructure (eg static-site)"
    echo "Enter the value for APP_UNIQUE_NAME:"
    read APP_UNIQUE_NAME

    echo
    echo "APP_DOMAIN - A valid domain name (eg example.com)"
    echo "Enter the value for APP_DOMAIN:"
    read APP_DOMAIN

    echo
    echo "APP_HOSTED_ZONE_ID - Existing AWS Route53 Hosted Zone ID for the domain (eg Z248xxxCT25)"
    echo "Enter the value for APP_HOSTED_ZONE_ID:"
    read APP_HOSTED_ZONE_ID
  fi

  echo
  echo "Creating the config file ~/configs.env"
  echo

  echo "APP_UNIQUE_NAME=${APP_UNIQUE_NAME}" > ${PWD}/configs.env;
  echo "APP_DOMAIN=${APP_DOMAIN}" >> ${PWD}/configs.env;
  echo "APP_HOSTED_ZONE_ID=${APP_HOSTED_ZONE_ID}" >> ${PWD}/configs.env;

  echo "cat ~/configs.env"
  echo
  cat ${PWD}/configs.env

fi

echo "

---------- aws profile (~/.aws) ----------

mounting ~/.aws from your workstation.
checking for aws profile ${AWS_PROFILE_NAME}.
"

confirm_aws_profile() {
  profile_status=$( (aws configure --profile ${1} list ) 2>&1 )
  if [[ $profile_status = *'could not be found'* ]]; then 
    echo "profile ${1} has NOT been setup. Configure it now for deployments to AWS.";
    echo 'If you are not ready to setup your AWS profile you can run `make aws_configure` later.'
    echo

    echo ' The set of permissions that have been tested for this repo, for bootstrap and deploy commands, are:

  - IAMFullAccess, AmazonSSMFullAccess, ecr:*
  - AmazonS3FullAccess, CloudFrontFullAccess, AmazonRoute53FullAccess, AWSCloudFormationFullAccess
'

    echo
    read -p "Do you want to configure AWS credentials now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        aws configure --profile ${1}
    fi

  else
    echo "profile ${1} has been setup:";
    echo
    aws configure --profile ${1} list
    echo
  fi
}

read -p "Set AWS Profile Name [${AWS_PROFILE_NAME}]: " AWS_PROFILE_NAME
AWS_PROFILE_NAME=${AWS_PROFILE_NAME:-static-site}
echo

confirm_aws_profile ${AWS_PROFILE_NAME}



software_info



echo
echo "setup complete."
echo