Feature: Domain Profile

  Background:
    * url baseUrl
    * def alice = call read('classpath:user-create.feature') { username: 'test-alice' }
    * def cat = call read('classpath:user-create.feature') { username: 'test-cat' }
    * def unique = call read('classpath:timestamp.js')
    * def wonderlandName = 'wonderland-'+unique
    * def wonderland = call read('classpath:domain-create.feature') { name: '#(wonderlandName)', manager: '#(alice.token)', member: '#(cat.reference)'}

  Scenario: Domain member can not create domain profile
    Given path '/profiles'
    And header Authorization = cat.token
    And request { domain: { domainReference: '#(wonderland.reference)'},  attributes: {'eat': 'me'} }
    When method POST
    Then status 403

  Scenario: Domain manager can create domain profile
    Given path '/profiles'
    And header Authorization = alice.token
    And request { domain: {domainReference: '#(wonderland.reference)'},  attributes: {'eat': 'me'} }
    When method POST
    Then status 201

  Scenario: Domain member can see profile
    # make sure domain profile exists first
    Given path '/profiles'
    And header Authorization = alice.token
    And request { domain: {domainReference: '#(wonderland.reference)'}, attributes: {'drink': 'me'} }
    When method POST
    Then status 201
    And def profile = response.reference
    # then get a fresh token! (cos cat wasn't a member of the domain when the current token was minted)
    Given path '/auth'
    And header Authorization = call read('classpath:basic-auth.js') { username: '#(cat.actualUsername)', password: '#(cat.password)' }
    When method GET
    Then status 200
    And def newToken = 'Bearer '+response
    # then check the member can see the profile
    Given path '/profiles', profile
    And header Authorization = newToken
    When method GET
    Then status 200
