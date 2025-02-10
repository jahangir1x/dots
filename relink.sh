#!/bin/bash

start_stowing() {
    # tmux
    stow -v -t $HOME --restow tmux

    # vscode
    stow -v -t ${HOME}/.config/Code/User --restow vscode-config
    stow -v -t ${HOME}/.config --restow vscode-injections

    # shell
    stow -v -t $HOME --restow shell
    stow -v -t $HOME/.local --restow shell-extend

    # vim
    stow -v -t $HOME --restow vim

    # kitty
    stow -v -t ${HOME}/.config --restow kitty

    # hyprland
    stow -v -t ${HOME}/.config --restow hyprland

    # ags
    stow -v -t ${HOME}/.config --restow ags
    stow -v -t ${HOME}/.local/state --restow ags-state

    # fastfetch
    stow -v -t ${HOME}/.config --restow fastfetch

    # overrides
    stow -v -t ${HOME}/.local/override --restow overrides

    # autokey [deprecated]
    stow -v -t ${HOME}/.config --restow autokey-deprecated

    # fuzzel
    stow -v -t ${HOME}/.config --restow fuzzel
}

start_stowing 2>&1 | sed -E "s/^(LINK:)/\x1b[1;97;42m\1\x1b[0m/g" \
                   | sed -E "s/^(UNLINK:)/\x1b[1;97;42m\1\x1b[0m/g" \
                   | sed -E "s/^(WARNING!)/\x1b[1;97;41m\1\x1b[0m/g"