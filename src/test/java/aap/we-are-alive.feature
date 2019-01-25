Feature: All components are alive

  Background:
    * url baseUrl

  Scenario: Users are alive
    Given path '/ping'
    When method GET
    Then status 200
    And match $ == "pong"

  Scenario: Domains are alive
    Given path '/info'
    When method GET
    Then status 200
    And match $.name == "aap-domains-api"

  Scenario: Profiles are alive
    Given path '/profiles/info'
    When method GET
    Then status 200
    And match $.name == "aap-profiles-api"
