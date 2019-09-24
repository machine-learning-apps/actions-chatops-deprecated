FROM alpine:latest

LABEL "com.github.actions.name"="Trigger Events From PR Comments"
LABEL "com.github.actions.description"="Listen for specific comments in a PR and emit a true/false indicator if comment occured, along with the branch name, PR number and SHA for downstream tasks."
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="white"

RUN apk --no-cache add jq bash curl git git-lfs
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]