*** Settings ***
Library             RequestsLibrary
Resource            common.resource

Suite Setup         Setup Suite
Suite Teardown      Teardown Suite


*** Keywords ***
Setup Suite
    Log To Console    Setup Suite
    Create Session    ${GLOBAL_SESSION}    ${BASE_URL}
    ${password}=    Determine Current Password
    Create Global Session    ${USERNAME}    ${password}

Teardown Suite
    Log To Console    Teardown Suite
    Delete All Sessions


