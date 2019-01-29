Feature: I can haz permissions

  Background:
    * url baseUrl
    * def hatter = callonce read('classpath:user-create.feature') { username: 'test-mad-hatter' }
    * def rabbit = callonce read('classpath:user-create.feature') { username: 'test-rabbit' }
    #add new users(alice and crazyGuy) and new domain(aliceIsland) to play with domain authorisation scenarios
    * def alice = call read('classpath:user-create.feature')  { username: 'test-alice' }
    * def crazyGuy = call read('classpath:user-create.feature')  { username: 'new-user' }
    * print 'new user is crazyGuy:',crazyGuy
    * def unique = call read('classpath:timestamp.js')
    * def domainName = 'test-authrization-'+unique
    * def aliceIsland = call read('classpath:domain-create.feature') { name: '#(domainName)', manager: '#(alice.token)', member: '#(rabbit.reference)' }
    * def domainReference = aliceIsland.reference

  Scenario: Anyone can create a domain
    Given def timestamp = call read('classpath:timestamp.js')
    And def domainName = 'test-authz-'+timestamp
    When def domain = call read('classpath:domain-create.feature') { name: '#(domainName)', manager: '#(hatter.token)', member: '#(rabbit.reference)' }
    Then match domain.reference == '#string'

  Scenario: A manager can add members
  #Add member to the domain(test-authrization-+timestamp)
    Given path '/domains',domainReference,hatter.reference,'user'
    And header Authorization =  alice.token
    And request {}
    When method PUT
    Then status 200

  Scenario: A manager can add another manager
   #add manager to the domain - /dom-{domainReference}/managers/usr-{userReference}
    Given path '/domains', domainReference,'managers',rabbit.reference
    And header Authorization = alice.token
    And request {}
    When method PUT
    Then status 200

  Scenario: A member cannot add another member
    Given path '/domains',domainReference,crazyGuy.reference,'user'
    And header Authorization =  hatter.token
    And request {}
    When method PUT
    Then status 403

  Scenario: A member cannot add a manager
    Given path '/domains', domainReference,'managers',crazyGuy.reference
    And header Authorization = hatter.token
    And request {}
    When method PUT
    Then status 403
