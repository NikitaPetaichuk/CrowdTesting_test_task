*** Variables ***
# Authentication data
${app_id}=        # Enter your Reddit application ID instead of this comment
${secret_key}=    # Enter your Reddit application secret key instead of this comment
${username}=      # Enter your Reddit username instead of this comment
${password}=      # Enter your Reddit password instead of this comment

# Dictionaries for requests
&{headers}=       User-Agent=TestingApp/0.0.1
&{auth_data}=     grant_type=password
...               username=${username}
...               password=${password}

# Data used in tests
${post_id}=       t3_xeo5ab
${post_title}=    junior vs senior
${comment_body}=  This is a test comment sent with Reddit API.
