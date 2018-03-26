Feature: Create user and get a token

  Background:
    * url baseUrl

  Scenario:
    # create domain
    Given path '/domains'
    And header Authorization = manager
    And request { domainName: '#(name)' }
    When method POST
    Then status 201
    And def reference = response.domainReference
    # add any member
    Given path '/domains', reference, member, 'user'
    And header Authorization =  manager
    And request {}
    When method PUT
    Then status 200
