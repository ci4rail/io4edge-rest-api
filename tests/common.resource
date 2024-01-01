*** Settings ***
Library     RequestsLibrary


*** Variables ***
${BASE_URL}             https://192.168.24.129/api/v1
${USERNAME}             io4edge
${DEFAULT_PASSWORD}     core
${MOD_PASSWORD}         newpassword    # + 0 or 1
${CURRENT_PASSWORD}     \
${CERT_VERIFY}          ${FALSE}    # Set to ${TRUE} to verify the server's certificate or to a path to a CA bundle to use a custom certificate
# ${CERT_VERIFY}    ${CURDIR}/cert.pem
${FW_NAME}              fw-io4edge-rest
${GLOBAL_SESSION}       global_session
${APP}                  tps


*** Keywords ***
Make Basic Auth
    [Arguments]    ${user}=\    ${pass}=\
    IF    "${user}" == ""
        ${user}=    Set Variable    ${USERNAME}
    END
    IF    "${pass}" == ""
        ${pass}=    Set Variable    ${CURRENT_PASSWORD}
    END

    ${auth}=    Evaluate    ("${user}","${pass}")
    RETURN    ${auth}

Create Global Session
    [Arguments]    ${user}=\    ${pass}=\
    Delete All Sessions
    ${auth}=    Make Basic Auth    ${user}    ${pass}
    Create Session
    ...    ${GLOBAL_SESSION}
    ...    ${BASE_URL}
    ...    verify=${CERT_VERIFY}
    ...    auth=${auth}
    ...    timeout=5
    ...    max_retries=5

Determine Current Password
    @{passwords}=    Create List    ${DEFAULT_PASSWORD}    ${MOD_PASSWORD}0    ${MOD_PASSWORD}1

    # try all passwords
    FOR    ${password}    IN    @{passwords}
        Log To Console    Trying password: ${password}
        ${auth}=    Make Basic Auth    ${USERNAME}    ${password}
        TRY
            Get On Session
            ...    ${GLOBAL_SESSION}
            ...    /firmware
            ...    auth=${auth}
            ...    expected_status=200
            ...    verify=${CERT_VERIFY}
            Set Global Variable    ${CURRENT_PASSWORD}    ${password}
            Log To Console    current password: ${password}
            RETURN    ${password}
        EXCEPT
            Log To Console    failed password: ${password}
        END
    END
    FAIL    Could not determine current password

Restart Device
    POST On Session    ${GLOBAL_SESSION}    /command/restart    expected_status=200
    Create Global Session