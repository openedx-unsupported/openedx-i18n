# Open edX i18n

This project contains dumps of the translation/localization files from [Transifex](https://www.transifex.com/open-edx/) for the Open edX project. It allows you to download internationalization (i18n) files without a Transifex account.

The content of this project is of little use in itself. In particular, it is used in [Tutor](https://github.com/overhangio/tutor) to package i18n files into the [Open edX Docker image](https://hub.docker.com/r/overhangio/openedx/).

When required, .po files were manually patched to fix compilation issues.

# Requirements

- [Docker](https://docs.docker.com/engine/installation/)
- `make`

# Configuration

You will need a Transifex API token to download new translation strings. First, obtain a token in your Transifex account: https://www.transifex.com/user/settings/api/

Then, add the token to the `transifexrc` file in this repository:

    [https://www.transifex.com]
    rest_hostname = https://rest.api.transifex.com
    token = your-token

This configuration file will automatically be bind-mounted in the Docker container at runtime.

# Usage

If you are feeling really confident, you can try to update translations in one go:

    make all

Note that you will need a [Transifex API token](https://www.transifex.com/user/settings/api/) to download translations.

It is quite likely that the downloaded transifex files will contain errors. After downloading the translation files (`make download`), you will then have to detect the errors by running:

    make validate

You will then have to fix the errors manually in each file. It is recommended to also fix them in Transifex.

After all errors have been fixed, you may resume the processing:

    make compile

# License

This code and all translation files are licensed under the terms of the [AGPL](https://www.gnu.org/licenses/agpl-3.0.en.html).
