*** Variables ***
# Authentication data
${app_id}=        SkoldCbk1Z02dw8FeA6BFw
${secret_key}=    HC2X6Jtjm_d0FgkT0GuUfH5aOF_zZg
${username}=      mrjosethk
${password}=      TestAccount123

# Dictionaries for requests
&{headers}=       User-Agent=TestingApp/0.0.1
&{auth_data}=     grant_type=password
...               username=${username}
...               password=${password}

# Data used in tests
${post_id}=       t3_xddm02
${post_title}=    Test post
${comment_body}=  This is a test comment sent with Reddit API.
