Feature: I can haz permissions

  Background:
    * url baseUrl
    * def hatter = callonce read('classpath:user-create.feature') { username: 'test-mad-hatter' }
    * def rabbit = callonce read('classpath:user-create.feature') { username: 'test-rabbit' }

  Scenario: Anyone can create a domain
    Given def timestamp = call read('classpath:timestamp.js')
    And def domainName = 'test-authz-'+timestamp
    When def domain = call read('classpath:domain-create.feature') { name: '#(domainName)', manager: '#(hatter.token)', member: '#(rabbit.reference)' }
    Then match domain.reference == '#string'

  @WIP
  Scenario: A manager can add members to their domain

  @WIP
  Scenario: A manager can add another manager

  @WIP
  Scenario: A member cannot add another member

  @WIP
  Scenario: A member cannot add a manager
