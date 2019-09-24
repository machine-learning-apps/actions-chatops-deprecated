![Actions Status](https://github.com/machine-learning-apps/actions-pr-commands/workflows/Tests/badge.svg)

# Trigger Actions From Comments In a PR

This action helps you trigger downstream actions with a custom command made via a comment in a pull request.  This Action listens to all comments made in pull requests and emits the output variable `triggered` as `true` (along with other variables) that you can use for branching downstream Actions.  Consider the below hello world example of this Action:

```bash

```

## Mandatory Inputs

1. `TRIGGER_PHRASE`: The phrase in a PR comment that you want to trigger downstream Actions.  Example - "/deploy-app-test".

## Optional Inputs

1. `PR_ACKNOWLEDGEMENT_COMMENT`: An optional comment to make in the PR if a triggering comment is detected.  This is meant to provide immediate feedback to the user that the triggering comment was detected.

2. `PR_ACKNOWLEDGEMENT_LABEL`: An optional label to add to the PR if a triggering comment is detected.  This is meant to provide immediate feedback to the user that the triggering comment was detected.

3. `TEST_EVENT_PATH`: An alternate place to fetch the payload for testing and debugging when making changes to this Action.  This is set to they system environment variable $GITHUB_EVENT_PATH by default.

4. `DEBUG`: Setting this variable to any value will turn debug mode on. This prints the body of the comment to stdout.

## Outputs

1. `SHA`: The SHA of the branch on the PR at the time the triggering comment was made.
2. `BRANCH_NAME`: The name of the branch corresponding to the PR.
3. `PR_NUMBER`: The number of the PR, ex: `https://github.com/{owner}/{repo}/pull/{PR_NUMBER}`.
4. `COMMENTER_USERNAME`: The GitHub username of the person that made the triggering comment in the PR.
5. `TRIGGERED`: this is a boolean value that is either `true` or `false` depending on if a triggering comment was made in a PR.

These outputs are useful for downstream Actions that you want to trigger with your PR command. For example, you might decide to pass the `SHA` or the `BRANCH_NAME to the [actions/checkout](https://github.com/actions/checkout) Action as the `ref` input to clone the branch associated with the comment.
