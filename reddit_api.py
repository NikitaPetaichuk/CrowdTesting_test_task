from typing import Dict

import requests


def get_access_token(
        app_id: str,
        secret_key: str,
        headers: Dict,
        auth_data: Dict
):
    url = "https://www.reddit.com/api/v1/access_token"
    auth = requests.auth.HTTPBasicAuth(app_id, secret_key)
    response = requests.post(url, auth=auth, headers=headers, data=auth_data).json()
    return response["access_token"]


def get_post_by_id(
        post_id: str,
        headers: Dict
):
    url = f"https://oauth.reddit.com/api/info?id={post_id}"
    return requests.get(url, headers=headers)


def get_post_comments(
        post_id: str,
        headers: Dict
):
    post_id_suffix = post_id[3:]
    url = f"https://oauth.reddit.com/comments/{post_id_suffix}"
    return requests.get(url, headers=headers).json()


def send_comment_to_post(
        post_id: str,
        comment_body: str,
        headers: Dict,
):
    url = f"https://oauth.reddit.com/api/comment?thing_id={post_id}&text={comment_body}"
    return requests.post(url, headers=headers)


def delete_comment(
        comment_id: str,
        headers: Dict
):
    url = f"https://oauth.reddit.com/api/del"
    data = {
        "id": comment_id
    }
    return requests.post(url, headers=headers, data=data)
