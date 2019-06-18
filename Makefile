PWD ?= $$(pwd)

DOCKER_RUN=docker run --rm -it \
	-e SETTINGS=locale \
	-v $(PWD)/edx-platform/locale.py:/openedx/edx-platform/lms/envs/locale.py \
	-v $(PWD)/edx-platform/xblocks/:/openedx/edx-platform/xblocks/ \
	-v $(PWD)/edx-platform/locale/:/openedx/edx-platform/conf/locale/ \
	regis/openedx:hawthorn

all: download compile clean ## Download and compile translations from transifex

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
	$(DOCKER_RUN) python xblocks/xblocks.py
