#!/usr/bin/env bash

get_quote() {
    sqlite3 -separator " - " ~/playground/quotes/quotes.db \
        "SELECT quote, REPLACE(author, '\"', '') AS author FROM quotes \
        WHERE (
                  author LIKE '%socrates%' \
            OR    author LIKE '%plato%' \
            OR    author LIKE '%aristotle%' \
            OR    author LIKE '%seneca%' \
            OR    author LIKE '%epictetus%' \
            OR    author LIKE '%marcus aurelius%' \
            OR    author LIKE '%montaigne%' \
            OR    author LIKE '%schopenhauer%' \
            OR    author LIKE '%nietzsche%' \
            OR    author LIKE '%diogenes%' \
            OR    author LIKE '%kierkegaard%' \
            OR    author LIKE '%pythagoras%' \
        ) \
        AND LENGTH(quote) < 100 \
        ORDER BY RANDOM() LIMIT 1;"
}

if [ ! -f /tmp/__quote_data ]; then
    get_quote > /tmp/__quote_data
fi

if [ $(find /tmp/__quote_data -mmin +1) ]; then
    previous_quote_data=$(cat /tmp/__quote_data)
    rm /tmp/__quote_data
    get_quote > /tmp/__quote_data
fi

quote_data=$(cat /tmp/__quote_data)

echo "📜 $quote_data"
