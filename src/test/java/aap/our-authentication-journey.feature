Feature: I can haz a token

  Scenario: Anyone can create an local account and get a token
    Given def anyone = call read('classpath:user-create.feature') { username: 'test-auth' }
    # Do we want to try it matches 'usr-<uuid>'? (or is that implementation details...)
    Then match anyone.reference == '#string'
    # Do we want to try validate it's an actual token?
    And match anyone.token == '#string'
