PROFILE_NAME=static-site
PROFILE =--profile ${PROFILE_NAME}
ACTIVATE_PYTHON=. .venv/bin/activate &&
CDK_CONTEXT=-c namespace=${APP_UNIQUE_NAME} -c domain_name=${APP_DOMAIN} -c hosted_zone_id=${APP_HOSTED_ZONE_ID} -c hosted_zone_name=${APP_DOMAIN}.

help:
	@grep -E '^[1-9a-zA-Z_-]+:.*?## .*$$|(^#--)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m %-43s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m #-- /[33m/'
	
	@echo
	@echo 'Run the following to active python virtual env:'
	@echo "source .venv/bin/activate"
	@echo
	@echo 'Run the following to exit python virtual env:'
	@echo "deactivate"
	@echo
	@echo "Example CDK command:"
	@echo "${ACTIVATE_PYTHON} cdk command ${PROFILE} ${CDK_CONTEXT}"
	@echo

#-- Manage CDK Project
.PHONY: clean
clean: ## remove ./venv folder
	rm -rf ./.venv

.PHONY: deps
deps: ## load python dependencies, even if .venv exists
	make _deps;
.PHONY: deps_check
deps_check:
	@echo "checking for .venv"
	@if [ ! -d ./.venv ]; then \
		echo "No .venv file found, building python deps"; \
		make _deps; \
	fi
_deps:
	python3 -m venv .venv \
	&& ${ACTIVATE_PYTHON} pip install -r requirements.txt

#-- CDK Commands
.PHONY: bootstrap
bootstrap: deps_check ## `cdk bootstrap` - deploys the CDK toolkit stack into an AWS environment
	${ACTIVATE_PYTHON} cdk bootstrap ${PROFILE} ${CDK_CONTEXT}

.PHONY: ls
ls: deps_check ## `cdk ls`        - list all stacks in the app
	${ACTIVATE_PYTHON} cdk ls ${PROFILE} ${CDK_CONTEXT}

.PHONY: synth
synth: deps_check ## `cdk synth`     - emits the synthesized CloudFormation template
	${ACTIVATE_PYTHON} cdk synth ${PROFILE} ${CDK_CONTEXT}

.PHONY: diff
diff: deps_check ## `cdk diff`      - compare deployed stack with current state
	${ACTIVATE_PYTHON} cdk diff ${PROFILE} ${CDK_CONTEXT}

.PHONY: deploy
deploy: deps_check ## `cdk deploy`    - deploy this stack to your default AWS account/region
	${ACTIVATE_PYTHON} cdk deploy ${PROFILE} ${CDK_CONTEXT}
