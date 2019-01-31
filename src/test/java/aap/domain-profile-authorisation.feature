#While writing this feature- domain manager doesn't have access to the domain profile.
# Only domain member has access, But later on we added the feature/fixed the issue that the
# domain manager can see the domain profile.Update tests as per the fix.


Feature: Domain profile manager and member role verification

  Background:
    * url baseUrl
    * def brilliantUser = call read('classpath:user-create.feature') { username: 'test-brilliant' }
    * def crazyGuy = call read('classpath:user-create.feature')  { username: 'new-user' }
    * def alice = call read('classpath:user-create.feature')  { username: 'test-alice' }
    * def unique = call read('classpath:timestamp.js')
    * def wonderlandName = 'wonderland-'+unique
    * def wonderland = callonce read('classpath:domain-create.feature') { name: '#(wonderlandName)', manager: '#(brilliantUser.token)',member: '#(brilliantUser.reference)'}
    * def domainReference = wonderland.reference
    #domain created to implement second scenario
    * def domainName = 'test-authrization-'+unique
    * def aliceIsland = call read('classpath:domain-create.feature') { name: '#(domainName)', manager: '#(alice.token)', member: '#(brilliantUser.reference)' }
    * def aliceIslandReference = aliceIsland.reference

  Scenario: Domain manager as a member role verification
    Given path '/profiles'
    And header Authorization = brilliantUser.token
    And request { domain: {domainReference: '#(wonderland.reference)'},  attributes: {'eat': 'me'} }
    When method POST
    Then status 201
    And def profile = response.reference

   #Domain manager can(get)see domain profile
    Given path '/profiles',profile
    And header Authorization = brilliantUser.token
    When method GET
    Then status 200

    #Add domain member
    Given path '/domains', domainReference,brilliantUser.reference,'user'
    And header Authorization =  brilliantUser.token
    And request {}
    When method PUT
    Then status 200

    #Domain member can see the profile without refreshing the token
    Given path '/profiles', profile
    And header Authorization = brilliantUser.token
    When method GET
    Then status 200

  #Above scenario focused more on manager acting as a member. But below scenario focusing on
  # individual users authorization in the domain.

  Scenario: Verify manager and member authorisation in the domain.

    Given path '/profiles'
    And header Authorization = alice.token
    And request { domain: {domainReference: '#(aliceIsland.reference)'},  attributes: {'drink': 'me'} }
    When method POST
    Then status 201
    And def profile = response.reference

    #Domain manager can(get)see domain profile
    Given path '/profiles',profile
    And header Authorization = alice.token
    When method GET
    Then status 200

    Given path '/profiles', profile
    And header Authorization = crazyGuy.token
    When method GET
    Then status 403

    #Add domain member
    Given path '/domains',aliceIslandReference,crazyGuy.reference,'user'
    And header Authorization =  alice.token
    And request {}
    When method PUT
    Then status 200
    
    #get crazyGuy membership details
    Given path '/users',crazyGuy.reference,'domains'
    And header Authorization =  crazyGuy.token
    When method GET
    Then status 200

    # As per ENA assumption, member can see the domain profile without refreshing token after membership,
    # I think their assumption is correct,we proved here, without refreshing the token member can access the domain profile.
    Given path '/profiles', profile
    And header Authorization = crazyGuy.token
    When method GET
    Then status 200
