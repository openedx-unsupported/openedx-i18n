.DEFAULT_GOAL := help

PWD ?= $$(pwd)
USERID ?= $$(id -u)

DOCKER_RUN=docker run --rm -it \
	-v $(PWD)/edx-platform/locale/:/openedx/edx-platform/conf/locale/ \
	openedx-i18n
DOCKER_RUN_TRANSIFEX=docker run --rm -it \
	-v $(PWD)/edx-platform/locale/:/openedx/edx-platform/conf/locale/ \
	-v $(PWD)/transifexrc:/openedx/.transifexrc \
	openedx-i18n

all: build download validate compile ## Download and compile translations from transifex

transifexrc: ## Make sure an empty transifexrc credentials file exists
	touch transifexrc

shell: transifexrc ## Open a bash shell in the openedx container
	$(DOCKER_RUN) bash

build: ## Build the docker image that contains translations
	docker build -t openedx-i18n --build-arg USERID=$(USERID) ./docker

download: transifexrc ## Download i18n files from transifex
	$(DOCKER_RUN_TRANSIFEX) i18n_tool transifex --config=conf/locale/config-extra.yaml pull

validate: ## Check for errors in translation files
	$(DOCKER_RUN) i18n_tool validate --config=conf/locale/config-extra.yaml

compile: ## Compile i18n files
	$(DOCKER_RUN) bash -c "\
		cd conf/locale && i18n_tool generate -v --config=./config-extra.yaml"

clean: ## Clean useless i18n files
	git clean -Xfd -- edx-platform/

help: ## generate this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
