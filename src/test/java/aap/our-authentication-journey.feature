Feature: I can haz a token

  Background:
    * url baseUrl
    * def unique = callonce read('classpath:timestamp.js')
    * def name = 'test-'+unique

  Scenario: Anyone can create an local account
    Given path '/auth'
    And request { username: '#(name)', password: '#(unique)', confirmPwd: '#(unique)', email: 'aap+test@ebi.ac.uk', name: 'Test Auth Journey', organisation: 'EBI SDO'}
    When method POST
    Then status 200

  Scenario: User with local account can get a token
    Given path '/auth'
    And header Authorization = call read('classpath:basic-auth.js') { username: '#(name)', password: '#(unique)' }
    When method GET
    Then status 200
