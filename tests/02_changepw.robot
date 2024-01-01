*** Settings ***
Library     RequestsLibrary
Library     String
Resource    common.resource


*** Test Cases ***
Change Password
    IF    "${CURRENT_PASSWORD}" == "${MOD_PASSWORD}0"
        ${new_password}=    Set Variable    ${MOD_PASSWORD}1
    ELSE
        ${new_password}=    Set Variable    ${MOD_PASSWORD}0
    END
    ${body}=    Create Dictionary    password=${new_password}

    ${response}=    PUT on session
    ...    ${GLOBAL_SESSION}
    ...    /users/${USERNAME}/basic_auth
    ...    json=${body}
    ...    expected_status=200

    # Check if we access works with new password
    Set Global Variable    ${CURRENT_PASSWORD}    ${new_password}
    Create Global Session
    ${response}=    GET on session    ${GLOBAL_SESSION}    /firmware    expected_status=200

Change Password with too Short Password
    ${body}=    Create Dictionary    password=1234567
    ${response}=    PUT on session
    ...    ${GLOBAL_SESSION}
    ...    /users/${USERNAME}/basic_auth
    ...    json=${body}
    ...    expected_status=400
    Should Be Equal As Strings    ${response.json()}[message]    password length invalid

Change Password with too Long Password
    ${pw}=    Generate Random String    65    [LETTERS][NUMBERS]
    ${body}=    Create Dictionary    password=${pw}
    ${response}=    PUT on session
    ...    ${GLOBAL_SESSION}
    ...    /users/${USERNAME}/basic_auth
    ...    json=${body}
    ...    expected_status=400
    Should Be Equal As Strings    ${response.json()}[message]    password length invalid
