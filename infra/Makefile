ACTIVATE_PYTHON=. .venv/bin/activate &&

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
.PHONY: ls
ls: deps_check ## `cdk ls`     - list all stacks in the app
	${ACTIVATE_PYTHON} cdk ls

.PHONY: synth
synth: deps_check ## `cdk synth`  - emits the synthesized CloudFormation template
	${ACTIVATE_PYTHON} cdk synth

.PHONY: diff
diff: deps_check ## `cdk diff`   - compare deployed stack with current state
	${ACTIVATE_PYTHON} cdk diff

.PHONY: deploy
deploy: deps_check ## `cdk deploy` - deploy this stack to your default AWS account/region
	${ACTIVATE_PYTHON} cdk deploy
