#!/bin/bash

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

# neofetch
stow -v -t ${HOME}/.config --restow neofetch

# overrides
stow -v -t ${HOME}/.local/override --restow overrides