# Open edX i18n

This project contains dumps of the translation/localization files from [Transifex](https://www.transifex.com/open-edx/) for the Open edX project. It allows you to download internationalization (i18n) files without a Transifex account.

The content of this project is of little use in itself. In particular, it is used in [openedx-docker](https://github.com/regisb/openedx-docker) to package i18n files into the [Open edX Docker image](https://hub.docker.com/r/regis/openedx/).

When required, .po files were manually patched to fix compilation issues.

# Requirements

- [Docker](https://docs.docker.com/engine/installation/)
- `make`

# Usage

Update translations:

    make all

Note that you will need a Transifex API token to download translations.

# License

This code and all translation files are licensed under the terms of the [AGPL](https://www.gnu.org/licenses/agpl-3.0.en.html).
