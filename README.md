# GoogleSheetI18n
Docker image: https://hub.docker.com/r/godeltech/googlesheeti18n

# Description
The G-i18n project is designed to simplify internationalization (i18n) for various types of projects, such as web applications, mobile apps, and desktop programs. It utilizes Google Sheets to manage translations as key-value pairs and provides a REST API for accessing these translations, making integration straightforward and user-friendly

# G-i18n introduction 
Many projects have to add support of i18n (internationalization) at some stage. There are multiple ways how engineers manage translations from implementation point of view and in most of the case it's quite complicated setup and process as such.

## Core concept 

The G-i18n project proposes simple-to-set-up and easy-to-use approach to address the i18n need for any type of project - e.g web application, mobile app or desktop program. 

It bases its ideas on very well known GoogleSheets and REST API:

- In GoogleSheet we keep translations as key-value pairs and may control access to this file for all collaborators (developers, translators, POs etc.) via embedded mechanisms of GoogleSheets - thus we don't have to spend any time on building UI to provide restricted access to tranlation lookups.

- REST API gives access to those key-value pairs, taking responsibility for parsing your GoogleSheets, caching data, implementing some fallback solutions.
This simplifies integration into any type of application.

## Sample data

This proof of concept uses the following GoogleSheets document as the source: [Translations POC](https://docs.google.com/spreadsheets/d/156UC1_Y2mwhGfY7Y-8RDiNM75eavFwzxBFNP9emNTzc/edit).

Each tab represents a namespace (e.g. a page of the website), and expected to contain translations to different languages as columns in the following format:

Key | language-1 | language-2 | ...
-|-|-|-
label1.id | language-1 translation | language-2 translation | ... 
label2.id | language-1 translation | language-2 translation | ...

For example:

ID | en-US | en-GB
-|-|-
color.gray | Color: gray  | Colour: grey  
word.flavor | Flavor | Flavour
word.analyze | Analyze | Analyse

# Getting Started

## Prereqisites
- [.NET 5.0 SDK](https://dotnet.microsoft.com/download/dotnet/5.0) to build the G-i18n tool (namely REST API)
- [Google developer account](https://console.developers.google.com) to run the app against Google Sheets
- "docker" if you want to build a docker image and run it within docker container

## Quick Start

In order to run the G-i18n project a few simple steps are required.

1. Create a google service account following [authenticating as a service account](https://cloud.google.com/docs/authentication/production) manual

2. Download the service account credentials file (e.g. `credentials.json`), which should look like the following:

```
  {
        "type": "service_account",
        "project_id": ####,
        "private_key_id": ####,
        "private_key":####,
        "client_email": ####,
        "client_id": ####,
        "auth_uri": "####,
        "token_uri": ####,
        "auth_provider_x509_cert_url": ####,
        "client_x509_cert_url": ####
  }
```
3. Update appropriate launch options' (which you're prefer to run) environment variables to use the service account credentials, e.g. if you use `IIS Express` option - update the following in `GoogleSheetI18n.Api\Properties\launchSettings.json`:

```
    "IIS Express": {
        "environmentVariables": {
            "GOOGLE_APPLICATION_CREDENTIALS": "c:\\Downloads\\credentials.json"
        }
    }
```
4. Build the API and run it. There are no special dependencies or caveats so just restore Nuget packages before the build, and you should be fine.

# Docker support

## Pull and run

You may want to just pull and run a Docker image. To achieve that run the following commangs:

> docker pull docker pull godeltech/googlesheeti18n:3661

*where `3661` is the desired tag at [Docker Hub](https://hub.docker.com/r/godeltech/googlesheeti18n/tags)

> docker run -i -e LOCAL_STORE_PATH="local-store" -e SPREADSHEET_ID="156UC1_Y2mwhGfY7Y-8RDiNM75eavFwzxBFNP9emNTzc" -e GOOGLE_APPLICATION_CREDENTIALS_AS_JSON=’{   \"type\": \"service_account\", ... }’ -e ASPNETCORE_ENVIRONMENT="Development" -p 8080:80 godeltech/googlesheeti18n:3661

*where `GOOGLE_APPLICATION_CREDENTIALS_AS_JSON`'s value is your personal full Google Application Credentials JSON (escaped, e.g. with double quotes `"` look like `\"`)

## Build and run

Alternatively, you may want to build the docker image of the tool locally instead. To do that you will need a few commands mentioned below:

> docker build .

> docker run -i -e LOCAL_STORE_PATH="local-store" -e SPREADSHEET_ID="156UC1_Y2mwhGfY7Y-8RDiNM75eavFwzxBFNP9emNTzc" -e GOOGLE_APPLICATION_CREDENTIALS_AS_JSON=’{   \"type\": \"service_account\", ... }’ -e ASPNETCORE_ENVIRONMENT="Development" -p 8080:80

# Sample Web client

1. Restore npm packages in `samples\WebClient` by running `npm install`

2. Start the client by running `npm start` in the same folder. It will host and run the application in development mode at http://localhost:3000.

3. Or use docker-compose

> docker-compose up


# Production use notes
There are a few thing you should know before you start.

We fetch all the options from `GoogleSheetI18n\src\GoogleSheetI18n.Api\appsettings.json`, `GoogleSheetI18n.Api\Properties\launchSettings.json` files and/or environment variables

We use Google Sheets as a storage, so we expect a valid Google Sheet ID in either:
- `SpreadsheetId` value in `appsettings.json`; 
OR 
- `SPREADSHEET_ID` environment variable.

We use [Google cloud (service) credentials](https://cloud.google.com/docs/authentication/production) for accessing Google Sheets, so we expect them to be provided to the app. There are a few options:
- Via setting path to file with credentials to `GOOGLE_APPLICATION_CREDENTIALS` environment variable; OR
- Via setting credentials encoded json into `GOOGLE_APPLICATION_CREDENTIALS_AS_JSON` environment variable; OR
- Via setting path to file with credentails to `CredentialsFilePath` variable in `appsettings.json`.

We currently use local file system for backups (local cache) as the only option, so let us know the folder via either:
- `LocalStoreFolderPath` value in `appsettings.json`; OR
- `BACKUP_FOLDER_PATH` environment variable.

# Special thanks to contributors

- [Aliaksandr Khlebus](https://github.com/akhlebus)
- [Olga Adasko](https://github.com/VolhaAdaska)
- [Dima Shubkin](https://github.com/watby)

# License
This project is licensed under the MIT License. See the LICENSE file for more details.
