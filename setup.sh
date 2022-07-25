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
- setup of AWS CLI profile named `static-site`

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

You should have a registered domain and HostedZone in Route53.

You will need the following values handy for a successful deployment:

- APP_DOMAIN=www.example.com
- APP_HOSTED_ZONE_NAME=example.com
- APP_HOSTED_ZONE_ID=123xxxV1C

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
fi

# if the user doesn't want to delete the config we should skip setting it at all
if [ "$SETUP_CONFIGS_FILE" = true ] ; then

  echo "Note: Config values aren't used yet so it's fine to set them to dummy data for now."
  echo "Update config in infra/cdk.json manually."
  echo 
  read -p "Configure configs.env with real data? Select no to load dummy data (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo
    echo "Enter the value for APP_DOMAIN:"
    read APP_DOMAIN

    echo
    echo "Enter the value for APP_HOSTED_ZONE_NAME:"
    read APP_HOSTED_ZONE_NAME

    echo
    echo "Enter the value for APP_HOSTED_ZONE_ID:"
    read APP_HOSTED_ZONE_ID
  fi

  echo
  echo "Creating the config file ~/configs.env"
  echo

  echo "APP_DOMAIN=${APP_DOMAIN}" > ${PWD}/configs.env;
  echo "APP_HOSTED_ZONE_NAME=${APP_HOSTED_ZONE_NAME}" >> ${PWD}/configs.env;
  echo "APP_HOSTED_ZONE_ID=${APP_HOSTED_ZONE_ID}" >> ${PWD}/configs.env;

  echo "cat ~/configs.env"
  echo
  cat ${PWD}/configs.env

fi

echo '

---------- aws profile (~/.aws) ----------

mounting `~/.aws` from your workstation.
checking for aws profile `static-site`.
'

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
confirm_aws_profile 'static-site'



software_info



echo
echo "setup complete."
echo