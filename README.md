# Google/GSuite Hangouts Chat Notification Plugin

[![GitHub Release](https://img.shields.io/github/v/release/ROKT/hangouts-notify-buildkite-plugin.svg)](https://github.com/ROKT/hangouts-notify-buildkite-plugin/releases)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) to send notifications from Buildkite to Google Hangouts

## Example

The following pipeline will send a message to a defined webhook in Google Chat. To generate webhooks for Hangouts/Chat rooms refer to [the Google Chat documentation][webhooks].

```yaml
env:
  CHAT_WEBHOOK: "https://chat.googleapis.com/v1/spaces/SPACE_ID/messages?key=LONG_COMPLICATED_WEBHOOK_KEY&token=LONG_COMPLICATED_TOKEN"

steps:
  - label: 'Send Notification'
    command:
      simple-chat-message "$CHAT_WEBHOOK" <<EOF
      Sending an awesome msg
      EOF
    plugins:
      - ROKT/hangouts-notify#v0.10:
```

[webhooks]: https://developers.google.com/hangouts/chat/quickstart/incoming-bot-python#step_1_register_the_incoming_webhook

## Utilities for [card layouts][cards]

Google Chat also supports more complex messages, made up of widgets arranged into cards. There are some commands to help putting together the necessary JSON for such messages, like this:

```yaml
- label: ':mega: Notify about test result'
  command: |
    set -euo pipefail

    image_url="https://example.org/success-image"
    if [ "$$TEST_RESULT" == "failed" ]; then
      image_url="https://example.org/fail-image"
    fi

    chat-message "https://chat.googleapis.com/v1/spaces/SPACE_ID/messages?key=LONG_COMPLICATED_WEBHOOK_KEY&token=LONG_COMPLICATED_TOKEN" <<EOF
    {
      "cards": [{
        "header": {
          "title": "My fancy card!",
          "imageUrl": $$(json-string "$$image_url")
        },
        "sections": [{
          "widgets" [
            $$(chat-key-value
               "Test case 1"
               "$${TEST_RESULT_1}"
               "$$(chat-text-button "OPEN REPORT" "$$ARTIFACT_PATH_1")"),
            $$(chat-key-value
               "Test case 2"
               "$${TEST_RESULT_2}"
               "$$(chat-text-button "OPEN REPORT" "$$ARTIFACT_PATH_2")")
          ]
        }, {
          "widgets": [{
            "buttons": [$$(chat-text-button "GO TO BUILD" "$$BUILD_URL")]
          }]
        }]
      }]
    }
    EOF
  plugins:
    - ROKT/hangouts-notify#v0.10
```

More commands for card layouts can be added as the need arises, but you can also use any mechanism you like to generate the necessary JSON for Google Chat to render your message.

[cards]: https://developers.google.com/hangouts/chat/reference/message-formats/cards

## Utilities for deployments

When deploying it can be helpful to know which commits are going out. A `commit-summary` command is provided which will use the `git log` to get information about commits which are being added, or removed. Here is an example run in this repository, where hypothetically `1e3c83e` is currently deployed, and we are seeking to deploy `3012c0e`.

```bash
commit-summary "1e3c83e" "3012c0e"
```

> `3012c0e` allows for empty urls or report not available
>
> Removing commits
> `1e3c83e` Merge pull request #3 from daleront/master

For a deployment, it is most useful to use a tag representing your current release as the first argument, and `HEAD` as the second, like this:

```bash
commit-summary production HEAD
```

When using the `commit-summary` script, it is up to you to ensure that you have pulled the tags into the local clone. This can be done by adding a `git pull --tags` in your `command` block, before using `commit-summary`.

## Tests

The tests for this plugin can be run easily with `docker-compose`, like this:

```bash
docker-compose run --rm tests
```
