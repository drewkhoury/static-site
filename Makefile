SHELL=/bin/bash
CDK_DIR=infra
COMPOSE_BUILD = docker-compose build
COMPOSE_RUN = docker-compose run --rm base
PROFILE = --profile default
REGION = --region us-east-1
ACTIVATE_PYTHON=cd ${CDK_DIR} && . .venv/bin/activate &&

help:
	@grep -E '^[1-9a-zA-Z_-]+:.*?## .*$$|(^#--)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m %-43s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m #-- /[33m/'

_env:
	@echo
	@echo "######################## checking for ./configs.env"
	if [ ! -f ./configs.env ]; then \
		echo "No configs.env file found, genereating from env variables"; \
		touch configs.env; \
		echo "APP_DOMAIN=${APP_DOMAIN}" >> configs.env; \
		echo "APP_HOSTED_ZONE_NAME=${APP_HOSTED_ZONE_NAME}" >> configs.env; \
		echo "APP_HOSTED_ZONE_ID=${APP_HOSTED_ZONE_ID}" >> configs.env; \
	fi

#-- Main
.PHONY: sh
sh: _env ## shell into container
	${COMPOSE_RUN} /bin/sh

.PHONY: rebuild_img
rebuild_img: ## rebuild container images used by compose
	${COMPOSE_BUILD}


#-- Infra / CDK
.PHONY: deps_force
deps: ## get project/python dependencies, even if .venv exists (useful if you recently added new python requirements)
	${COMPOSE_RUN} make _deps;
.PHONY: deps
deps_check:
	@echo
	@echo "######################## checking for .venv"
	if [ ! -d ./${CDK_DIR}/.venv ]; then \
		echo "No .venv file found, building python deps"; \
		${COMPOSE_RUN} make _deps; \
	fi
_deps:
	cd ${CDK_DIR} \
	&& python3 -m venv .venv \
	&& . .venv/bin/activate \
	&& pip install -r requirements.txt

.PHONY: ls
ls: _env deps_check ## `cdk ls`    - list all stacks in the app
	${COMPOSE_RUN} make _ls
_ls:
	${ACTIVATE_PYTHON} cdk ls

.PHONY: synth
synth: _env deps_check ## `cdk synth` - emits the synthesized CloudFormation template
	${COMPOSE_RUN} make _synth
_synth:
	${ACTIVATE_PYTHON} cdk synth

