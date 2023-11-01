#!/bin/bash

send_alert() {
    echo "sending alert to the Amit sir"

    local topic_name=4zurE_sCrip7_sT4tus

    curl -d "$1" ntfy.sh/$topic_name
}
