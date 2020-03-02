# Google/GSuite Hangouts Chat Notification Plugin

[![GitHub Release](https://img.shields.io/github/v/release/dawshiek-yogathasar/hangouts-notify-buildkite-plugin.svg)](https://github.com/dawshiek-yogathasar/hangouts-notify-buildkite-plugin/releases)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) to send notifications from Buildkite to Google Hangouts

## Example

The following pipeline will send a message to a defined webhook in Google Chat. Note to generate Webhooks for Hangouts/Chat rooms refer to the following documentation: https://developers.google.com/hangouts/chat/quickstart/incoming-bot-python#step_1_register_the_incoming_webhook


### Simple Text Message with Commit Summary:
```yaml
steps:
  - label: 'Send Notification'
    plugins:
      - ROKT/hangouts-notify#v0.xxx (please refer to the latest version):
          chat-endpoint: "https://chat.foo.com/chat"
          webhook-url: "https://chat.googleapis.com/v1/spaces/blahblah"
          message: 'Sending an awesome msg\n'
          type: "SimpleTextMessage"
          commit-summary:
            enabled: true
            from-commit: "blah"
            to-commit: "blahblah"


```

### Simple Text Message without Commit Summary:
```yaml
steps:
  - label: 'Send Notification'
    plugins:
      - ROKT/hangouts-notify#v0.xxx (please refer to the latest version):
          chat-endpoint: "https://chat.foo.com/chat"
          webhook-url: "https://chat.googleapis.com/v1/spaces/blahblah"
          message: "Sending an awesome msg"
          type: "SimpleTextMessage"


```

### KeyValue Card Message:
```yaml
steps:
  - label: 'Send Notification'
    plugins:
      - ROKT/hangouts-notify#v0.xxx (please refer to the latest version):
          chat-endpoint: "https://chat.foo.com/chat"
          webhook-url: "https://chat.googleapis.com/v1/spaces/blahblah"
          message: "Sending an awesome msg"
          type: "KeyValueCARD"
          webhook-url2: "https://chat.googleapis.com/v1/spaces/blah"
          webhook-key: "my_webhook_key"
          usertoken-fail: "my_token_fail"
          usertoken-pass: "my_token_pass"
          # card-details contain three attribute: CARD_TITLE, CARD_SUBTITLE, BUILD_URL
          card-details: "Hourly Test,on the hour every hour, my url"
          # rows contain three attribute: ROW_TITLE, ROW_INFO, ROW_URL
          rows: "row_one title,row_one info,row_one url;row_two title,row_two info,row_two url;row_three title,row_three info,row_three url"



```

### Using Env Vars:
```yaml
env:
  NOTIFICATION_ENDPOINT: "https://chat.foo.com/chat"
  SRE_CHAT_WEBHOOK: "https://chat.googleapis.com/v1/spaces/blahblah"

steps:
  - label: 'Send Notification'
    plugins:
      - ROKT/hangouts-notify#v0.5:
          chat-endpoint: ${NOTIFICATION_ENDPOINT}
          webhook-url: ${SRE_CHAT_WEBHOOK}
          message: "Sending an awesome msg"

```

## Configuration

#### 1. Simple Text Message with Commit Summary:

- `chat-endpoint` (required, string)

  Proxy Endpoint that routes Google Chat Msgs.

- `webhook-url` (required, string)

  Webhook endpoint configured above. Required to send msgs to correct chat room.

- `message` (required, string)

  Message that you want to send.

- `type` (required, string)

  Type of Google Chat msgs that you want to send.

- `commit-summary` (required, object)
  
  Got Commit summary which generate by the script.

#### 2. Simple Text Message without Commit Summary:

- `chat-endpoint` (required, string)

  Proxy Endpoint that routes Google Chat Msgs.

- `webhook-url` (required, string)

  Webhook endpoint configured above. Required to send msgs to correct chat room.

- `message` (required, string)

  Message that you want to send.

- `type` (required, string)

  Type of Google Chat msgs that you want to send.

#### 3. KeyValue Card Message:
- `chat-endpoint` (required, string)

  Proxy Endpoint that routes Google Chat Msgs.

- `webhook-url` (required, string)

  Webhook endpoint configured above. Required to send msgs to correct chat room.

- `message` (required, string)

  Message that you want to send.

- `type` (required, string)

  Type of Google Chat msgs that you want to send.

- `webhook-url2` (required, string)

- `webhook-key` (required, string)

- `usertoken-fail` (required, string)

- `usertoken-pass` (required, string)

- `type` (required, string)

- `card-details` (required, string)

- `rows` (required, string)

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
