*** Settings ***
Library     Collections
Library     reddit_api.py
Resource    variables.robot


*** Test Cases ***
Checking Reddit API for posts and comments
    [Setup]  Authorize
    Getting The Post By Its ID
    Sending A Comment To The Post
    Deleting The Sent Comment


*** Keywords ***
Authorize
    ${access_token}=   Get Access Token  app_id=${app_id}
    ...                                  secret_key=${secret_key}
    ...                                  headers=${headers}
    ...                                  auth_data=${auth_data}
    Set To Dictionary  ${headers}        Authorization=bearer ${access_token}

Getting the post by its ID
    ${response}=                    Get Post By Id                post_id=${post_id}
    ...                                                           headers=${headers}
    Should Be Equal As Integers     ${response.status_code}       200
    ${response_body}=               Get Variable Value            ${response.json()}
    Log                             ${response_body}
    Dictionary Should Contain Key   ${response_body}              data
    ${response_data}=               Get From Dictionary           ${response_body}  data
    Dictionary Should Contain Key   ${response_data}              children
    Length Should Be                ${response_data["children"]}  1
    ${post_data}=                   Get From List                 ${response_data["children"]}  0
    Dictionary Should Contain Item  ${post_data}                  kind  ${post_id[:2]}  # Get post ID prefix and check with field value
    Dictionary Should Contain Key   ${post_data}                  data
    Check Post Main Info            ${post_data["data"]}

Check post main info
    [Arguments]  ${post_main_data}
    Dictionary Should Contain Item  ${post_main_data}  name   ${post_id}
    Dictionary Should Contain Item  ${post_main_data}  title  ${post_title}

Sending a comment to the post
    ${response}=                            Send Comment To Post     post_id=${post_id}
    ...                                                              comment_body=${comment_body}
    ...                                                              headers=${headers}
    Should Be Equal As Integers             ${response.status_code}  200
    ${response_body}=                       Get Variable Value       ${response.json()}
    Log                                     ${response_body}
    Dictionary Should Contain Item          ${response_body}         success   ${TRUE}
    ${comment_id}                           Extract Sent Comment ID  ${response_body}
    Log                                     ${comment_id}
    Wait Until Keyword Succeeds             5x  2 sec
    ...                                     Find Sent Comment In The Post Comments
    ...                                     ${comment_id}  ${TRUE}
    Set Test Variable                       ${comment_id}

Deleting the sent comment
    ${response}=                 Delete Comment           comment_id=${comment_id}
    ...                                                   headers=${headers}
    Log                          ${response.text}
    Should Be Equal As Integers  ${response.status_code}  200
    ${response_body}=            Get Variable Value       ${response.json()}
    Should Be Empty              ${response_body}
    Wait Until Keyword Succeeds  5x  2 sec
    ...                          Find Sent Comment In The Post Comments
    ...                          ${comment_id}  ${FALSE}


Extract sent comment id
    [Arguments]  ${response_body}
    ${jquery_list}=                 Get From Dictionary   ${response_body}  jquery
    ${comment_data}=                Get Variable Value    ${jquery_list[18][3][0][0]}
    Log                             ${comment_data}
    Dictionary Should Contain Item  ${comment_data}       kind  t1  # Checking comment type correctness
    Dictionary Should Contain Key   ${comment_data}       data
    ${comment_main_data}=           Get From Dictionary   ${comment_data}  data
    Dictionary Should Contain Key   ${comment_main_data}  name
    [Return]     ${comment_main_data["name"]}

Find sent comment in the post comments
    [Arguments]  ${comment_id}  ${should_be_found}
    ${post_comments}=     Get Post Comments   post_id=${post_id}
    ...                                       headers=${headers}
    Log                   ${post_comments}
    ${is_found}=          Get Variable Value  ${FALSE}
    ${comments_list}=     Get Variable Value  ${post_comments[1]["data"]["children"]}
    FOR  ${comment}  IN  @{comments_list}
        IF  "${comment["data"]["name"]}" == "${comment_id}"
            ${is_found}=  Get Variable Value  ${TRUE}
            BREAK
        END
    END
    Should Be Equal       ${is_found}         ${should_be_found}
