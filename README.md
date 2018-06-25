# AAP Tests

This project gathers the tests of the AAP (Authentication, Authorisation and 
Profile) which touch upon more than one service. They are API tests representing 
the different journeys our programmatic users take.

We have used [karate](https://github.com/intuit/karate) to describe the steps in 
these journeys in a clear syntax that gives us runnable tests.
  
## HOW-TO run  

The tests are run as part of the build:
```bash
  ./gradlew clean build
```

By default, the tests will run against the explore instance of the AAP 
(https://explore.api.aai.ebi.ac.uk). This can be changed in the 
[karate-config.js](src/test/java/karate-config.js).

The tests will produce JUnit compatible [XML reports](build/test-results/test), as well as human-friendly 
[test results](build/reports/tests/test/index.html). 

## Pre-requisite

Java 8 and gradle

Some tests rely on variables being set: these are imported directly from environment variables
(like `AAP_SDO_TEST_PREFIX_PASSWORD` for [prefix.feature](src/test/java/aap/prefix.feature)). We
automatically import any environment variable that start with `AAP_`.

