#!/usr/bin/env bash

exit_status=0
if [ ! -f /tmp/__quote_data ]; then
    curl -m 3 -s -k -L -o /tmp/__quote_data 'https://zenquotes.io/api/random'
    exit_status=$?
fi
if [[ $exit_status -ne 0 ]]; then
    echo "" > /tmp/__quote_data
fi

# check if quote data was created within 1 minute
exit_status=0
if [ $(find /tmp/__quote_data -mmin +1) ]; then
    previous_quote_data=$(cat /tmp/__quote_data)
    rm /tmp/__quote_data
    curl -m 3 -s -k -L -o /tmp/__quote_data 'https://zenquotes.io/api/random'
    exit_status=$?
fi
if [[ $exit_status -ne 0 ]]; then
    echo "$previous_quote_data" > /tmp/__quote_data
fi
quote=$(cat /tmp/__quote_data | jq -r '.[0].q')
author=$(cat /tmp/__quote_data | jq -r '.[0].a')

echo "📜 $quote - $author"
