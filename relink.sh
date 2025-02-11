#!/bin/bash

start_stowing() {
    # home
    stow -v -t ${HOME} --restow home

    # usr
    sudo stow -v -t /usr --restow usr
}

start_stowing 2>&1 | sed -E "s/^(LINK:)/\x1b[1;97;42m\1\x1b[0m/g" \
                   | sed -E "s/^(UNLINK:)/\x1b[1;97;42m\1\x1b[0m/g" \
                   | sed -E "s/^(WARNING!)/\x1b[1;97;41m\1\x1b[0m/g"