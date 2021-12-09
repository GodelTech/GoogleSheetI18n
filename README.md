# Introduction 
Many projects add support of i18n (internationalization) at some stage. There are multiple ways how engineers manage translations from implementation point of view, but translation teams often use Google Sheets for some reason. Engineers usually carry these translations on their own.

As software engineers, we decided to try using Google Sheets for translations directly, as the only source of truth. With caching, fallback, and hopefully no pain.

This proof of concept uses the following Google Sheet document as the source: [Translations POC](https://docs.google.com/spreadsheets/d/156UC1_Y2mwhGfY7Y-8RDiNM75eavFwzxBFNP9emNTzc/edit)

Each tab represents a namespace, and expected to contain transtations in the following format:

ID | language-tag | other-language-tag | ...
-|-|-|-
some.id | Some translation | Some other translation | ... 
another.id | Another translation | Another translation | ...

For example:

ID | en-US | en-GB
-|-|-
color.gray | Color: gray  | Colour: grey  
word.flavor | Flavor | Flavour
word.analyze | Analyze | Analyse

# Getting Started
## Prereqisites
- [.NET 5.0 SDK](https://dotnet.microsoft.com/download/dotnet/5.0) to build the app
- [Google developer account](https://console.developers.google.com) to run the app against Google Sheets

## Quick Start
In order to run i18n project a few simple steps are required.

### Backend part (API)
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

### Sample Web client

1. Restore npm packages in `samples\WebClient` by running `npm install`

2. Start the client by running `npm start` in the same folder. It will host and run the application
    > The application starts in development mode
    
    > The application will be available at http://localhost:3000

## Build the API
There is no specia dependencies or caveats. So just restore Nuget packages before the build, and you should be fine.

## Run API for Production
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

## Special thanks to contributors

- [Aliaksandr Khlebus](https://github.com/akhlebus)
- [Olga Adasko](https://github.com/VolhaAdaska)
- [Dima Shubkin](https://github.com/watby)