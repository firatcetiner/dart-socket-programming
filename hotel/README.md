# hotel api

Hotel API stands for establishing the information exchange between the HotelDB and TravelAgency. The Hotel Server will simply implement basic HTTP routes for TravelAgency to fetch data from the remote Hotel Database.

## Running the Application Locally

Run `bin/main.dart`. By default, a configuration file named `config.yaml` will be used.

To generate a SwaggerUI client, run `aqueduct document client`.

## Running Application Tests

To run all tests for this application, run the following in this directory:

```
pub run test
```

The default configuration file used when testing is `config.src.yaml`. This file should be checked into version control. It also the template for configuration files used in deployment.
