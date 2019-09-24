#!/bin/bash
set -e
shopt -s expand_aliases
alias no_trigger="echo ::set-output name=triggered::false && exit 0"

#check inputs
if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ -z "$INPUT_TRIGGER_PHRASE" ]]; then
	echo "Set the TRIGGER_PHRASE input."
	exit 1
fi

if [ "$TEST_EVENT_PATH" ]; then
  GITHUB_EVENT_PATH=$TEST_EVENT_PATH 
fi

echo "GH Event Path" $GITHUB_EVENT_PATH
ls $GITHUB_EVENT_PATH

# skip if trigger phase does not exist
echo "Checking if comment contains '${INPUT_TRIGGER_PHRASE}' command..."
COMMENT_BODY=$(jq -r ".comment.body" "$GITHUB_EVENT_PATH")
echo "COMMENT BODY:"
echo $COMMENT_BODY
(echo $COMMENT_BODY | grep -q "${INPUT_TRIGGER_PHRASE}") || no_trigger

# skip if not a PR
echo "Checking if issue is a pull request..."
(jq -r ".issue.pull_request.url" "$GITHUB_EVENT_PATH") || no_trigger

# skip if not a new comment
if [[ "$(jq -r ".action" "$GITHUB_EVENT_PATH")" != "created" ]]; then
	echo "This is not a new comment event!"
	no_trigger
fi

# Query the GitHub API to get information about the PR for which the comment was made
PR_NUMBER=$(jq -r ".issue.number" "$GITHUB_EVENT_PATH")
GH_USER_HANDLE=$(jq -r ".comment.user.login" "$GITHUB_EVENT_PATH")
echo "Collecting information about PR #$PR_NUMBER of $GITHUB_REPOSITORY..."

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

pr_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" \
          "${URI}/repos/$GITHUB_REPOSITORY/pulls/$PR_NUMBER")


BASE_REPO=$(echo "$pr_resp" | jq -r .base.repo.full_name)
HEAD_REPO=$(echo "$pr_resp" | jq -r .head.repo.full_name)
HEAD_BRANCH=$(echo "$pr_resp" | jq -r .head.ref)
HEAD_SHA=$(echo "$pr_resp" | jq -r .head.sha)

if [[ -z "$BASE_BRANCH" ]]; then
	echo "Cannot get base branch information for PR #$PR_NUMBER!"
	echo "API response: $pr_resp"
	exit 1
fi

# ensure this is not a fork #
if [[ "$BASE_REPO" != "$HEAD_REPO" ]]; then
	echo "PRs from forks are not supported at the moment."
	exit 1
fi

# Emit output variables
echo "::set-output name=SHA::${HEAD_SHA}"
echo "::set-output name=BRANCH_NAME::${HEAD_BRANCH}"
echo "::set-output name=PR_NUMBER::${PR_NUMBER}"
echo "::set-output name=COMMENTER_HANDLE::${GH_USER_HANDLE}"
echo "::set-output name=COMMENT_BODY::${COMMENT_BODY}"

