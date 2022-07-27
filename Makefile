# varibles used by make
SHELL=/bin/bash
CDK_DIR=infra
COMPOSE_BUILD = docker-compose build
COMPOSE_RUN_GENERIC = docker-compose run --rm
COMPOSE_RUN = docker-compose run --rm base
PROFILE =--profile ${AWS_PROFILE_NAME}
ACTIVATE_PYTHON=. .venv/bin/activate &&
CDK_CONTEXT=-c namespace=${APP_UNIQUE_NAME} -c domain_name=${APP_DOMAIN} -c hosted_zone_id=${APP_HOSTED_ZONE_ID} -c hosted_zone_name=${APP_DOMAIN}.

# user input
AWS_PROFILE_NAME ?=static-site

help: _env
	@grep -E '^[1-9a-zA-Z_-]+:.*?## .*$$|(^#--)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m %-43s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m #-- /[33m/'

_env:
	@if [ ! -f ./configs.env ]; then \
		echo "No configs.env file found, running setup ..."; \
		make _setup; \
	fi

_setup:
	touch configs.env
	${COMPOSE_RUN_GENERIC} -e AWS_PROFILE_NAME=${AWS_PROFILE_NAME} setup /bin/bash ./setup.sh

#-- Misc
.PHONY: sh
sh: _env ## launch a container with a terminal for adhoc commands (/bin/bash)
	${COMPOSE_RUN} /bin/bash

.PHONY: rebuild_img
rebuild_img: ## rebuild container images used by compose
	${COMPOSE_BUILD}

.PHONY: aws_configure
aws_configure: ## configure aws credentials for this project using profile AWS_PROFILE_NAME
	${COMPOSE_RUN_GENERIC} aws configure --profile ${AWS_PROFILE_NAME}


#-- Manage CDK Project
.PHONY: clean
clean: ## remove ./venv folder
	rm -rf ./${CDK_DIR}/.venv

.PHONY: deps
deps: ## load python dependencies, even if .venv exists
	${COMPOSE_RUN} make _deps;
.PHONY: deps_check
deps_check:
	@echo "checking for .venv"
	@if [ ! -d ./${CDK_DIR}/.venv ]; then \
		echo "No .venv file found, building python deps"; \
		${COMPOSE_RUN} make _deps; \
	fi
_deps:
	cd ${CDK_DIR} \
	&& python3 -m venv .venv \
	&& ${ACTIVATE_PYTHON} pip install -r requirements.txt

#-- CDK Commands

.PHONY: bootstrap
bootstrap: _env deps_check ## `cdk bootstrap`  - deploys the CDK toolkit stack into an AWS environment
	${COMPOSE_RUN} make _bootstrap
_bootstrap:
	cd ${CDK_DIR} && ${ACTIVATE_PYTHON} cdk bootstrap ${PROFILE} ${CDK_CONTEXT}

.PHONY: ls
ls: _env deps_check ## `cdk ls`         - list all stacks in the app
	${COMPOSE_RUN} make _ls
_ls:
	cd ${CDK_DIR} && ${ACTIVATE_PYTHON} cdk ls ${PROFILE} ${CDK_CONTEXT}

.PHONY: synth
synth: _env deps_check ## `cdk synth`      - emits the synthesized CloudFormation template
	${COMPOSE_RUN} make _synth
_synth:
	cd ${CDK_DIR} && ${ACTIVATE_PYTHON} cdk synth ${PROFILE} ${CDK_CONTEXT}

.PHONY: diff
diff: _env deps_check ## `cdk diff`       - compare deployed stack with current state
	${COMPOSE_RUN} make _diff
_diff:
	cd ${CDK_DIR} && ${ACTIVATE_PYTHON} cdk diff ${PROFILE} ${CDK_CONTEXT}

.PHONY: deploy
deploy: _env deps_check ## `cdk deploy`     - deploy this stack to your default AWS account/region
	${COMPOSE_RUN} make _deploy
_deploy:
	cd ${CDK_DIR} && ${ACTIVATE_PYTHON} cdk deploy ${PROFILE} ${CDK_CONTEXT}
