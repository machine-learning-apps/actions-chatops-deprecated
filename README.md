![Actions Status](https://github.com/machine-learning-apps/actions-pr-commands/workflows/Tests/badge.svg)

# Trigger Actions From Comments In a PR

This action helps you trigger downstream actions with a custom command made via a comment in a pull request.  This Action listens to all comments made in pull requests and emits the output variable `triggered` as `true` (along with other variables) that you can use for branching downstream Actions.  Consider the below hello world example of this Action:

```bash

```

1. `SHA`: The SHA of the branch on the PR at the time the triggering comment was made.
2. `BRANCH_NAME`: The name of the branch corresponding to the PR.
3. `PR_NUMBER`: The number of the PR, ex: `https://github.com/{owner}/{repo}/pull/{PR_NUMBER}`.
4. `COMMENTER_USERNAME`: The GitHub username of the person that made the triggering comment in the PR.
5. `TRIGGERED`: this is a boolean value that is either `true` or `false` depending on if a triggering comment was made in a PR.

For example, you might decide to pass the `SHA` or the `BRANCH_NAME to the [actions/checkout](https://github.com/actions/checkout#usage) Action as the `ref` input to clone the branch associated with the comment.
