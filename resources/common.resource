*** Settings ***
Library                         QForce
Library                         Collections
Library                         RequestsLibrary

*** Variables ***
${INBOX}                        test1                             # Recipients inbox name where you send messages to e.g. test1 in test1@your.mailinator.domain
${API_TOKEN}                    29bb4_snip_2a534                  # API Token from https://www.mailinator.com/v4/private/team_settings.jsp
                                                                  # Add the Token to your CRT secret variables under suite details section.
&{HEADERS}                      Authorization=${API_TOKEN}  Content-Type=application/json  Accept=application/json
&{PARAMS}                       limit=2  sort=descending          # query parameters, adjust if lots of emails incoming

*** Keywords ***
Fetch Latest Email Id
    [Documentation]    Return latest Mailinator email id for provided inbox and subject text
    [Arguments]        ${inbox}=${INBOX}  ${subject}=Test email subject
    ${response}=       GET  url=https://mailinator.com/api/v2/domains/private/inboxes/${INBOX}  params=&{PARAMS}  headers=&{HEADERS}
    ...                expected_status=200
    @{msgs}=           Get From Dictionary  ${response.json()}  msgs
    FOR  ${message}  IN  @{msgs}
        ${_subject}=  Get From Dictionary  ${message}  subject
        IF  "${_subject}" == "${subject}"
            ${id}=    Get From Dictionary  ${message}  id
            Log To Console  ${id}
            BREAK
        END
    END
    [Return]  ${id}

Fetch Links From Email
    [Documentation]    Return HTTPS links from Email for provided email id
    [Arguments]        ${id}
    ${response}=       GET  url=https://mailinator.com/api/v2/domains/private/messages/${id}/links  headers=${headers}
    ...                expected_status=200
    Log To Console     ${response.json()}
    @{links}=          Get From Dictionary  ${response.json()}  links
    [Return]           @{links}
