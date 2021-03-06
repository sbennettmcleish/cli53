@domain
Feature: domain management
  Scenario: I can create a domain
    When I run "cli53 create $domain --comment hi"
    Then the domain "$domain" is created

  Scenario: I can create a domain period
    When I run "cli53 create $domain. --comment hi"
    Then the domain "$domain" is created

  Scenario: I can create a VPC private domain
    When I run "cli53 create $domain --comment hi --vpc-id vpc-d70f05b5 --vpc-region eu-west-1"
    Then the domain "$domain" is created

  Scenario: I can delete a domain by name
    Given I have a domain "$domain"
    When I run "cli53 delete $domain"
    Then the domain "$domain" is deleted

  Scenario: I can delete a domain by name period
    Given I have a domain "$domain"
    When I run "cli53 delete $domain."
    Then the domain "$domain" is deleted

  Scenario: I can delete and purge a big domain
    Given I have a domain "$domain"
    When I run "cli53 import --file tests/big.txt $domain"
    And I run "cli53 delete --purge $domain"
    Then the domain "$domain" is deleted

  Scenario: I can list domains
    Given I have a domain "$domain"
    When I run "cli53 list"
    Then the output contains "$domain"

  Scenario: I can purge a domain
    Given I have a domain "$domain"
    When I run "cli53 rrcreate $domain 'a A 127.0.0.1'"
    And I run "cli53 rrpurge --confirm $domain"
    Then the domain "$domain" doesn't have record "a.$domain. 3600 IN A 127.0.0.1"

  Scenario: I can purge a domain with wildcard records
    Given I have a domain "$domain"
    When I run "cli53 rrcreate $domain '*.wildcard A 127.0.0.1'"
    And I run "cli53 rrpurge --confirm $domain"
    Then the domain "$domain" doesn't have record "*.wildcard.$domain. 3600 IN A 127.0.0.1"

  Scenario: I can export a domain
    Given I have a domain "$domain"
    When I run "cli53 rrcreate $domain 'a A 127.0.0.1'"
    And I run "cli53 export $domain"
    Then the output contains "$domain"

  Scenario: I can export a domain --full
    Given I have a domain "$domain"
    When I run "cli53 rrcreate $domain 'www A 127.0.0.1'"
    When I run "cli53 rrcreate $domain 'alias 86400 AWS ALIAS A www $self false'"
    And I run "cli53 export --full $domain"
    Then the output contains "alias.$domain.	86400	AWS	ALIAS	A www.$domain. $self false"
