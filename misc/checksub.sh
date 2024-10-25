#!/bin/bash

check_azcli() {
    if ! command -v az &>/dev/null; then
        echo "Azure CLI is not installed. Please install it to proceed."
        exit 1
    fi
}

check_azcli

active_subscriptions() {
    subscriptions=$(az account list --query '[?state==`Enabled`].{id:id, name:name}' -o tsv | sort -k2)
    # Loop through each subscription
    while IFS=$'\t' read -r subscription_id subscription_name; do
        # Check if the subscription name starts with "DevOps"
        if [[ $subscription_name == DevOps* ]]; then
            echo "Subscription ID: $subscription_id"
            echo "Subscription Name: $subscription_name"
            break
        fi
    done <<<"$subscriptions"
    az account set -s $subscription_name
    echo $subscription_name
}

active_subscriptions
