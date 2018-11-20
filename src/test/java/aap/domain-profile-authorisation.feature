Feature: Domain profile manager as a member role verification

  Background:
    * url baseUrl
    * def brilliantUser = call read('classpath:user-create.feature') { username: 'test-brilliant' }
    * def unique = call read('classpath:timestamp.js')
    * def wonderlandName = 'wonderland-'+unique
    * def wonderland = call read('classpath:domain-create.feature') { name: '#(wonderlandName)', manager: '#(brilliantUser.token)',member: '#(brilliantUser.reference)'}
    * def domainReference = wonderland.reference

  Scenario: Domain manager and member authorisation verification
    Given path '/profiles'
    And header Authorization = brilliantUser.token
    And request { domain: {domainReference: '#(wonderland.reference)'},  attributes: {'eat': 'me'} }
    When method POST
    Then status 201
    And def profile = response.reference

   #Domain manager can not see domain profile
    Given path '/profiles',profile
    And header Authorization = brilliantUser.token
    When method GET
    Then status 403

    #Add domain member
    Given path '/domains', domainReference,brilliantUser.reference,'user'
    And header Authorization =  brilliantUser.token
    And request {}
    When method PUT
    Then status 200

    # As per ENA assumption, member can see the domain profile without refreshing token after membership,
    # But we proved it that without refreshing the token user gets 403 after immediate membership
    Given path '/profiles', profile
    And header Authorization = brilliantUser.token
    When method GET
    Then status 403

   #refresh the token(cos 'brilliantUser' wasn't a member of the domain when the current token was minted)
    Given path '/token'
    And header Authorization = brilliantUser.token
    When method GET
    Then status 200
    And def newToken = 'Bearer '+response

  #Domain member can see the profile with refresh token
    Given path '/profiles', profile
    And header Authorization = newToken
    When method GET
    Then status 200
