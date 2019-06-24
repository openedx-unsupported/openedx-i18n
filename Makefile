PWD ?= $$(pwd)

DOCKER_RUN=docker run --rm -it \
	-e SETTINGS=locale \
	-v ~/.transifexrc:/root/.transifexrc \
	-v $(PWD)/edx-platform/locale.py:/openedx/edx-platform/lms/envs/locale.py \
	-v $(PWD)/edx-platform/xblocks/:/openedx/edx-platform/xblocks/ \
	-v $(PWD)/edx-platform/locale/:/openedx/edx-platform/conf/locale/ \
	regis/openedx:hawthorn

all: download compile clean ## Download and compile translations from transifex

chown:
	sudo chown -R $(USER) -- $(PWD)

shell:
	$(DOCKER_RUN) bash

download:
	$(DOCKER_RUN) i18n_tool transifex --config=conf/locale/config-extra.yaml pull

compile:
	$(DOCKER_RUN) bash -c "\
		cd conf/locale && i18n_tool generate -v --config=./config-extra.yaml"

# TODO remove me
compilemessages:
	$(DOCKER_RUN) bash -c "cd conf/locale && django-admin.py compilemessages -v1"

clean:
	git clean -Xfd -- edx-platform/


pull_translations:
	sudo rm -rf edx-platform/xblocks/repos/*
	$(DOCKER_RUN) python xblocks/xblocks_i18n.py
	make chown
	find edx-platform/xblocks/repos/ -maxdepth 1 -mindepth 1 -type d \
		-exec bash -c 'cd {} && git push --set-upstream local $(shell rev-parse --abbrev-ref HEAD)' \;
