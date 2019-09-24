FROM alpine:latest

LABEL "com.github.actions.name"="Trigger Events From PR Comments"
LABEL "com.github.actions.description"="Listen for specific comments in a PR and emit variables for downstream tasks. Can be used to enable chatops from PRs."
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="gray-dark"

RUN apk --no-cache add jq bash curl git
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
