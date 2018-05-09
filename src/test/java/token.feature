Feature: Get a token

  Background:
    * url baseUrl

  Scenario:
    Given path '/auth'
    And header Authorization = call read('classpath:basic-auth.js') { username: '#(username)', password: '#(password)' }
    When method GET
    Then status 200
    And def token = 'Bearer '+response