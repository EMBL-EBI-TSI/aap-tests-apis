Feature: Prefixed Domains

  Background:
    * url baseUrl
    * def prefix = 'test'
    * def expectedPrefixReference = 'dom-980fb038-87f4-4bed-a359-126b3bddba6e'
    * match AAP_SDO_TEST_PREFIX_PASSWORD != null
    * def prefixMember = callonce read('classpath:token.feature') {username: 'sdo-test-prefix', password: '#(AAP_SDO_TEST_PREFIX_PASSWORD)'}
    * def alice = call read('classpath:user-create.feature') { username: 'test-alice' }
    * def unique = call read('classpath:timestamp.js')

  Scenario: Domain manager can check validation template
    # first create a prefixed domain
    Given def prefixedName = 'test.somewhere-'+unique
    And def domain = call read('classpath:domain-create.feature') { name: '#(prefixedName)', manager: '#(prefixMember.token)', member: '#(alice.reference)' }
    # then get the reference of the prefix
    Given path '/domains', domain.reference, 'prefix'
    And header Authorization = prefixMember.token
    When method GET
    Then status 200
    And match response.domainReference == expectedPrefixReference
    # then grab the schema of the prefix profile
    Given path '/domains', expectedPrefixReference, 'profile'
    And header Authorization = prefixMember.token
    When method GET
    Then status 200
    And match response.schema contains '\"required\":[\"address\"]'
