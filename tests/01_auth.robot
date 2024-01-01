*** Settings ***
Library             RequestsLibrary
Resource            common.resource

Test Teardown       Restore Global Session


*** Test Cases ***
Access with Correct Credentials
    ${response}=    GET on session    ${GLOBAL_SESSION}    /firmware    expected_status=200
    Should Be Equal As Strings    ${response.json()}[name]    ${FW_NAME}

Access with Incorrect Username
    Create Global Session    user=not-io4edge
    ${response}=    GET on session    ${GLOBAL_SESSION}    /firmware    expected_status=401
    Should Be Equal As Strings    ${response.json()}[message]    wrong username

Access with Incorrect Password
    Create Global Session    pass=${CURRENT_PASSWORD}x
    ${response}=    GET on session    ${GLOBAL_SESSION}    /firmware    expected_status=401
    Should Be Equal As Strings    ${response.json()}[message]    wrong password

Access without Credentials
    [Template]    Access ${method} access to ${endpoint} Without Credentials Should Fail
    [Setup]    Create Session Without Authentication
    PUT    /users/${USERNAME}/basic_auth
    PUT    /certificate
    PUT    /key
    GET    /firmware
    PUT    /firmware
    GET    /hardware
    PUT    /hardware
    POST    /command/restart
    POST    /command/repl
    GET    /parameter/global/static-ip
    #PUT    /parameter/global/static-ip
    GET    /configuration/tps
    PUT    /configuration/tps


*** Keywords ***
Restore Global Session
    Create Global Session    user=${USERNAME}    pass=${CURRENT_PASSWORD}

Access ${method} access to ${endpoint} Without Credentials Should Fail
    Log To Console    m=${method} e=${endpoint}

    IF    "${method}" == "GET"
        ${response}=    GET On Session    ${GLOBAL_SESSION}    ${endpoint}    expected_status=401
    ELSE IF    "${method}" == "PUT"
        ${response}=    PUT On Session    ${GLOBAL_SESSION}    ${endpoint}    expected_status=401
    ELSE IF    "${method}" == "POST"
        ${response}=    POST On Session    ${GLOBAL_SESSION}    ${endpoint}    expected_status=401
    ELSE
        Fail    Unknown method: ${method}
    END
    Should Be Equal As Strings    ${response.json()}[message]    no authorization header

Create Session Without Authentication
    Delete All Sessions
    Create Session    ${GLOBAL_SESSION}    ${BASE_URL}    verify=${CERT_VERIFY}
