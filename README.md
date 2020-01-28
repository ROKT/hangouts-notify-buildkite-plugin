# Google/GSuite Hangouts Chat Notification Plugin

[![GitHub Release](https://img.shields.io/github/v/release/dawshiek-yogathasar/hangouts-notify-buildkite-plugin.svg)](https://github.com/dawshiek-yogathasar/hangouts-notify-buildkite-plugin/releases)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) to send notifications from Buildkite to Google Hangouts

## Example

The following pipeline will send a message to a defined webhook in Google Chat. Note to generate Webhooks for Hangouts/Chat rooms refer to the following documentation: https://developers.google.com/hangouts/chat/quickstart/incoming-bot-python#step_1_register_the_incoming_webhook


### Standard:
```yaml
steps:
  - label: 'Send Notification'
    plugins:
      - dawshiek-yogathasar/hangouts-notify#v0.5:
          chat-endpoint: "https://chat.foo.com/chat"
          webhook-url: "https://chat.googleapis.com/v1/spaces/blahblah"
          message: "Sending an awesome msg"

```

### Using Env Vars:
```yaml
env:
  NOTIFICATION_ENDPOINT: "https://chat.foo.com/chat"
  SRE_CHAT_WEBHOOK: "https://chat.googleapis.com/v1/spaces/blahblah"

steps:
  - label: 'Send Notification'
    plugins:
      - dawshiek-yogathasar/hangouts-notify#v0.5:
          chat-endpoint: ${NOTIFICATION_ENDPOINT}
          webhook-url: ${SRE_CHAT_WEBHOOK}
          message: "Sending an awesome msg"

```

## Configuration

- `chat-endpoint` (required, string)

  Proxy Endpoint that routes Google Chat Msgs.

- `webhook-url` (required, string)

  Webhook endpoint configured above. Required to send msgs to correct chat room.

- `message` (required, string)

  Message that you want to send.

## Hangouts card integration

- To build the webhookURL and allow for different notifications from a "FAIL" user and a "PASS" user
  'webhook-url2'
  'webhook-key'
  'usertoken-pass'
  'usertoken-fail'

- You will have to pass the 'TYPE' as card, if left empty or doesn't exist, the old way will be used
  'type: 'CARD''

- Use the following for card title, subtitile and card openLink. Fields are separated by a comma
  'card-details: <title>, <subtitle, <build link>>'

- Pass in the row DETAILS. Each card has 3 fields separated by a comma. each card is separated by ;
  'rows: <card1title>, <card1result>, <build link>'
  OR
  'rows: <card1title>, <card1result>, <build1 link>; <card2title>, <card2result>, <build2 link>'

### TODO:
- Native Google Webhook Endpoint without proxy Endpoint (coming soon)
