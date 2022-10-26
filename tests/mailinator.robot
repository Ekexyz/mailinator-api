*** Settings ***
Documentation                   Mailinator REST API automation
Resource                        ../resources/common.resource

*** Test Cases ***
Get Salesforce Verification Links
    [Documentation]            Note: Tested with finnish language email from Salesforce so adjust subject and inbox name as fit.
    [Tags]                     Mailinator  API
    ${id}=                     Fetch Latest Email Id    inbox=test1  subject=Tervetuloa Salesforceen: Vahvista tilisi
    @{links}=                  Fetch Links From Email    id=${id}
    Log List                   ${links}
    Log                        Url: ${links[1]}
    # GoTo                     ${links[1]}