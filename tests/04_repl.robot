*** Settings ***
Library     RequestsLibrary
Library     String
Resource    common.resource

*** Test Cases ***

Execute Repl Heap Command
    ${body}=   Set Variable  heap
    ${response}=    POST On Session    ${GLOBAL_SESSION}    command/repl  data=${body}  expected_status=200
    Log To Console  ${response.content}
    ${resp_string}=    Convert To String    ${response.content}
    Should Contain  ${resp_string}  Free heap:

Execute Non-Existing Repl Command
    ${body}=   Set Variable  non-existing
    ${response}=    POST On Session    ${GLOBAL_SESSION}    command/repl  data=${body}  expected_status=400
    Should Be Equal As Strings    ${response.json()}[message]    command not found

Execute Repl Command With Invalid Data
    ${body}=   Set Variable  hw-inv fef ege geg
    ${response}=    POST On Session    ${GLOBAL_SESSION}    command/repl  data=${body}  expected_status=200
    ${resp_string}=    Convert To String    ${response.content}
    Should Contain  ${resp_string}  command returned failure 

