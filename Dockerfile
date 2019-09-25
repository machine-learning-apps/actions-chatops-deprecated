FROM alpine:latest

LABEL "com.github.actions.name"="ChatOps For Actions"
LABEL "com.github.actions.description"="Enables ChatOps by listening for specific comments in a PR and emitting variables for downstream tasks."
LABEL "com.github.actions.icon"="message-square"
LABEL "com.github.actions.color"="gray-dark"

RUN apk --no-cache add jq bash curl
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
