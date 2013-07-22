Feature: Create Events
  In order to track application usage
  As an application
  I want to send events to the backend

  @webservice
  Scenario Outline: Query Strings
    When <event_type> events are posted
    Then I should get a "success=<success>" response
    And I <event_log_should> see the events in the event.log
    And I <test_log_should> warning in the test.log
    
    Examples:
      | event_type     | success | event_log_should | test_log_should             | 
      | valid          | true    | should           | should not see a            |
      | empty          | true    | should not       | should not see a            |
      | missing params | true    | should not       | should see a MISSING_PARAMS |

  @webservice
  Scenario Outline: Versions
    When events with version <version> are posted
    Then I should get a "success=<success>" response
    And I <event_log_should> see the events in the event.log
    And I <test_log_should> warning in the test.log

    Examples:
      | version     | success | event_log_should | test_log_should          |
      | 1.0         | true    | should           | should not see a         |
      | 1.0.0.0     | true    | should           | should not see a         |
      | 0001.0      | true    | should           | should not see a         |
      | 010.000     | true    | should           | should not see a         |
      | 2.0.0.0     | true    | should           | should not see a         |
      | 1.00001.0.0 | true    | should           | should not see a         |
      | 1.123457890 | true    | should           | should not see a         |
      | v1.0        | true    | should           | should not see a         |
      | 0.9.0.0     | false   | should not       | should see a BAD_VERSION |
      | 0.10.0.0    | false   | should not       | should see a BAD_VERSION |
      | 1.a         | false   | should not       | should see a BAD_VERSION |
      | 0.9b        | false   | should not       | should see a BAD_VERSION |
      | 1..0        | false   | should not       | should see a BAD_VERSION |

  # NOTE: token validation is done within Hadoop now
#  @webservice
#  Scenario: Invalid Token
#    When invalid token events are posted
#    Then I should get a "success=true" response
#    And I should not see the events in the event.log
#    And I should see a BAD_TOKEN warning in the test.log
