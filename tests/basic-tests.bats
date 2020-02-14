#!/usr/bin/env bats
# -*- sh -*-

load "$BATS_PATH/load.bash"

# Uncomment to enable stub debugging
# export CURL_STUB_DEBUG=/dev/tty

@test "passes payload through directly" {
    stub curl "-v : cat -"

    . $PWD/hooks/environment
    run "$PWD/bin/chat-message" "endpoint" <<EOF
{
  "cards": [{
    "header": {
      "title": "card with header"
    }
  }]
}
EOF

    assert_output --partial '"title":"card with header"'

    assert_success
    unstub curl
}

@test "simple chat message does what it says on the box" {
    stub curl "-v : cat -"

    . $PWD/hooks/environment
    run "$PWD/bin/simple-chat-message" "endpoint" <<EOF
This is a message, that I want to send, "with a quote!"
EOF

    assert_output <<EOF
{"text":"This is a message, that I want to send, \"with a quote!\""}
EOF

    assert_success
    unstub curl
}

@test "works for the complex case that we're imagining" {
    stub curl "-v : cat -"

    IMAGE_URL="https://example.org/some-image"
    BUILD_URL="https://example.org/some-build"
    TEST_RESULT_1=Passed
    ARTIFACT_PATH_1="https://example.org/some-build-1"
    TEST_RESULT_2=FAILED
    ARTIFACT_PATH_2="https://example.org/some-build-2"
    TEST_RESULT_3=FAILED
    ARTIFACT_PATH_3="https://example.org/some-build-3"

    . $PWD/hooks/environment
    run "$PWD/bin/chat-message" "endpoint" <<EOF
{
  "cards": [{
    "header": {
      "title": "Hourly Test",
      "subtitle": "on the hour every hour",
      "imageUrl": $(json-string "$IMAGE_URL")
    },
    "sections": [{
      "widgets": [
        $(chat-key-value            \
           "Test case 1"             \
           "${TEST_RESULT_1}"     \
           "$(chat-text-button "OPEN REPORT" "$ARTIFACT_PATH_1")"),
        $(chat-key-value            \
           "Test case 2"  \
           "${TEST_RESULT_2}"     \
           "$(chat-text-button "OPEN REPORT" "$ARTIFACT_PATH_2")"),
        $(chat-key-value            \
           "Test case 3"                \
           "${TEST_RESULT_3}" \
           "$(chat-text-button "OPEN REPORT" "$ARTIFACT_PATH_3")")
      ]
    }, {
      "widgets": [{
        "buttons": [$(chat-text-button "GO TO BUILD" "$BUILD_URL")]
      }]
    }]
  }]
}
EOF

    expected_output=$(jq --compact-output . <<EOF
    {
      "cards": [
        {
          "header": {
            "title": "Hourly Test",
            "subtitle": "on the hour every hour",
            "imageUrl": "https://example.org/some-image"
          },
          "sections": [
            {
              "widgets": [
                {
                  "keyValue": {
                    "topLabel": "Test case 1",
                    "content": "Passed",
                    "button": {
                      "textButton": {
                        "text": "OPEN REPORT",
                        "onClick": {
                          "openLink": {
                            "url": "https://example.org/some-build-1"
                          }
                        }
                      }
                    }
                  }
                },
                {
                  "keyValue": {
                    "topLabel": "Test case 2",
                    "content": "FAILED",
                    "button": {
                      "textButton": {
                        "text": "OPEN REPORT",
                        "onClick": {
                          "openLink": {
                            "url": "https://example.org/some-build-2"
                          }
                        }
                      }
                    }
                  }
                },
                {
                  "keyValue": {
                    "topLabel": "Test case 3",
                    "content": "FAILED",
                    "button": {
                      "textButton": {
                        "text": "OPEN REPORT",
                        "onClick": {
                          "openLink": {
                            "url": "https://example.org/some-build-3"
                          }
                        }
                      }
                    }
                  }
                }
              ]
            },
            {
              "widgets": [
                {
                  "buttons": [
                    {
                      "textButton": {
                        "text": "GO TO BUILD",
                        "onClick": {
                          "openLink": {
                            "url": "https://example.org/some-build"
                          }
                        }
                      }
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
EOF)

    assert_output "$expected_output"

    assert_success
    unstub curl
}
