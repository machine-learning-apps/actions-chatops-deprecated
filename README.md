![Actions Status](https://github.com/machine-learning-apps/actions-chatops/workflows/Tests/badge.svg)

# Trigger Actions With ChatOps (Comments In a PR)

This action helps you trigger downstream actions with a custom command made via a comment in a pull request, otherwhise known as [ChatOps](https://www.pagerduty.com/blog/what-is-chatops/).  This Action listens to all comments made in pull requests and emits the output variable `triggered` as `true` (along with other variables) that you can use for branching downstream Actions.  Consider the below toy example that triggers downstream actions with the command `/trigger-something-with-this`

## Example Usage

```yaml
name: Demo
on: [issue_comment] # PRs == Issues in GitHub

jobs:
  demo:
    runs-on: ubuntu-latest
    steps:

        # This step listens to all PR events for the triggering phrase
      - name: listen for PR Comments
        id: prcomm
        uses: machine-learning-apps/actions-chatops@master
        with:
          TRIGGER_PHRASE: "/trigger-something-with-this"
          PR_ACKNOWLEDGEMENT_LABEL: "demo-label"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      # This step clones the branch of the PR associated with the triggering phrase, but only if it is triggered.
      - name: clone branch of PR
        if: steps.prcomm.outputs.TRIGGERED == 'true'
        uses: actions/checkout@master
        with:
          ref: ${{ steps.prcomm.outputs.SHA }}

      # This step is a toy example that illustrates how you can use outputs from the pr-command action
      - name: print variables
        if: steps.prcomm.outputs.TRIGGERED == 'true'
        run: echo "${USERNAME} made a triggering comment on PR# ${PR_NUMBER} for ${BRANCH_NAME}"
        env: 
          BRANCH_NAME: ${{ steps.prcomm.outputs.BRANCH_NAME }}
          PR_NUMBER: ${{ steps.prcomm.outputs.PR_NUMBER }}
          USERNAME: ${{ steps.prcomm.outputs.COMMENTER_USERNAME }}
```

A demonstration of this in action can be found on [this PR](https://github.com/machine-learning-apps/actions-pr-commands/pull/5).

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
5. `TRIGGERED`: this is a boolean value that is either `true` or `false` depending on if a triggering comment was detected in a PR.  This is an important outptut variable that you may want to condition downstream Actions to run on with an `if:` statement (see example at the beginning).

These outputs are useful for downstream Actions that you want to trigger with your PR command. For example, you might decide to pass the `SHA` or the `BRANCH_NAME to the [actions/checkout](https://github.com/actions/checkout) Action as the `ref` input to clone the branch associated with the comment.
