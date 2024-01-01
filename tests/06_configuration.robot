*** Settings ***
Library         RequestsLibrary
Library         String
Resource        common.resource

Suite Setup     Clear Configuration





*** Test Cases ***
Check Defaults are Applied
    Verify Default Configuration
    Restart Device
    Verify Default Configuration

Apply Full Configuration Without Errors
    ${params}=    Create Dictionary
    ...    param1=foo
    ...    param2=bar
    ...    param3=foobar
    ...    param4=barfoo
    Apply Configuration    1.0    ${params}    200
    Restart Device
    ${response}=    GET On Session    ${GLOBAL_SESSION}    /configuration/${APP}
    Log To Console    ${response.json()}
    Should Be Equal As Strings    ${response.json()}[version]    1.0
    Should Be Empty    ${response.json()}[unsupported_parameters]
    Should Be Empty    ${response.json()}[invalid_parameters]
    Should Be Empty    ${response.json()}[missing_parameters]
    Should Be Equal As Strings    ${response.json()}[parameters][param1]    foo
    Should Be Equal As Strings    ${response.json()}[parameters][param2]    bar
    Should Be Equal As Strings    ${response.json()}[parameters][param3]    foobar
    Should Be Equal As Strings    ${response.json()}[parameters][param4]    barfoo

Apply Configuration with Unsupported Parameters
    ${params}=    Create Dictionary
    ...    param1=foo
    ...    param2=bar
    ...    param3=foobar
    ...    param4=barfoo
    ...    param_extra=extra
    Apply Configuration    2.0    ${params}    200
    Restart Device
    ${response}=    GET On Session    ${GLOBAL_SESSION}    /configuration/${APP}
    Log To Console    ${response.json()}
    Should Be Equal As Strings    ${response.json()}[version]    2.0
    Should Be Equal As Strings    ${response.json()}[unsupported_parameters]    ['param_extra']
    Should Be Empty    ${response.json()}[invalid_parameters]
    Should Be Empty    ${response.json()}[missing_parameters]
    Should Be Equal As Strings    ${response.json()}[parameters][param1]    foo
    Should Be Equal As Strings    ${response.json()}[parameters][param2]    bar
    Should Be Equal As Strings    ${response.json()}[parameters][param3]    foobar
    Should Be Equal As Strings    ${response.json()}[parameters][param4]    barfoo
    Should Be Equal As Strings    ${response.json()}[parameters][param_extra]    extra
    

*** Keywords ***
Clear Configuration
    [Documentation]    Clear the configuration by writing a configuration with no parameters
    ${params}=    Create Dictionary
    Apply Configuration    0.0    ${params}    200

Apply Configuration
    [Arguments]    ${version}    ${params}    ${expected_status}=200
    ${config}=    Create Dictionary
    ...    version=${version}
    ...    parameters=${params}

    ${response}=    PUT On Session
    ...    ${GLOBAL_SESSION}
    ...    /configuration/${APP}
    ...    json=${config}
    ...    expected_status=${expected_status}

Get Parameter
    [Arguments]    ${param}
    ${response}=    GET On Session    ${GLOBAL_SESSION}    /parameter/${APP}/${param}    expected_status=200
    ${value}=    Set Variable    ${response.json()}[value]
    RETURN    ${value}

Verify Default Configuration
    ${response}=    GET On Session    ${GLOBAL_SESSION}    /configuration/${APP}
    #Log To Console    ${response.json()}
    Should Be Equal As Strings    ${response.json()}[version]    0.0
    Should Be Empty    ${response.json()}[parameters]
    Should Be Empty    ${response.json()}[unsupported_parameters]
    Should Be Empty    ${response.json()}[invalid_parameters]
    Should Be Equal As Strings    ${response.json()}[missing_parameters]    ['param1', 'param2', 'param3', 'param4']
    ${param_value}=    Get Parameter    param1
    Should Be Equal As Strings    ${param_value}    test1
    ${param_value}=    Get Parameter    param2
    Should Be Equal As Strings    ${param_value}    test2
    ${param_value}=    Get Parameter    param3
    Should Be Equal As Strings    ${param_value}    test3
    ${param_value}=    Get Parameter    param4
    Should Be Equal As Strings    ${param_value}    test4
