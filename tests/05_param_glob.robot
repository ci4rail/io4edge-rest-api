*** Settings ***
Library     RequestsLibrary
Library     String
Resource    common.resource
# Works only if addressing is made via IP address


*** Test Cases ***
Change DeviceID
    ${newid}=    Generate Random String    10    [LETTERS][NUMBERS]
    ${body}=    Create Dictionary    value=${newid}
    ${response}=    PUT On Session
    ...    ${GLOBAL_SESSION}
    ...    /parameter/global/device-id
    ...    json=${body}
    ...    expected_status=200
    ${response}=    POST On Session    ${GLOBAL_SESSION}    /command/restart    expected_status=200
    Create Global Session
    ${response}=    GET On Session    ${GLOBAL_SESSION}    /parameter/global/device-id    expected_status=200
    Should Be Equal As Strings    ${response.json()}[value]    ${newid}

Read Non Existing Parameter Should Fail
    ${response}=    GET On Session    ${GLOBAL_SESSION}    /parameter/global/non-existing    expected_status=404
    Should Be Equal As Strings    ${response.json()}[message]    parameter not found

Write Non Existing Parameter Should Fail
    ${body}=    Create Dictionary    value=123
    ${response}=    PUT On Session
    ...    ${GLOBAL_SESSION}
    ...    /parameter/global/non-existing
    ...    json=${body}
    ...    expected_status=404
    Should Be Equal As Strings    ${response.json()}[message]    parameter not found

Write Parameter with Invalid Value Should Fail
    ${body}=    Create Dictionary    value=bla
    ${response}=    PUT On Session
    ...    ${GLOBAL_SESSION}
    ...    /parameter/global/static-ip
    ...    json=${body}
    ...    expected_status=400
    Should Be Equal As Strings    ${response.json()}[message]    invalid value

Write Parameter without Value Should Fail
    ${body}=    Create Dictionary
    ${response}=    PUT On Session
    ...    ${GLOBAL_SESSION}
    ...    /parameter/global/static-ip
    ...    json=${body}
    ...    expected_status=400
    Should Be Equal As Strings    ${response.json()}[message]    value missing