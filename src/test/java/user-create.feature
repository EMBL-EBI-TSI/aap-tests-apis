Feature: Create user and get a token

  Background:
    * url baseUrl

  Scenario:
    # create user
    Given path '/auth'
    And def timestamp = call read('classpath:timestamp.js')
    And def actualUsername = username + '-' + timestamp
    And request { username: '#(actualUsername)', password: '#(timestamp)', confirmPwd: '#(timestamp)', email: 'aap+test@ebi.ac.uk', name: 'Test Journey', organisation: 'EBI SDO'}
    When method POST
    Then status 200
    And def reference = response
    # and get a token (do we want to restrict the length?)
    Given path '/auth'
    And header Authorization = call read('classpath:basic-auth.js') { username: '#(actualUsername)', password: '#(timestamp)' }
    When method GET
    Then status 200
    And def token = 'Bearer '+response