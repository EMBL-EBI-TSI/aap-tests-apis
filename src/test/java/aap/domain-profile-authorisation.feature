#While writing this feature- domain manager doesn't have access to the domain profile.
# Only domain member has access, But later on we added the feature/fixed the issue that domain
# manager and member can see domain profile.Updating code as per the fix.


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

    # As per ENA assumption, member can see the domain profile without refreshing token after membership,
    # But we proved it that without refreshing the token user gets 403 after immediate membership
    #Here manger acting as member so he can access the profile without refreshing the token.
    #Hence moved status code from 403 to 200.
    #If member and manager are different, without refreshing token, member cannot access his/her profile.
    Given path '/profiles', profile
    And header Authorization = brilliantUser.token
    When method GET
    Then status 200

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
