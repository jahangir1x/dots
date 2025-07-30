if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ]; then
  # tmux attach a -d || tmux new && exit;
  tmux new
  exit
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DISABLE_MAGIC_FUNCTIONS=true
source /home/zinis/.local/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle colored-man-pages

# Auto complete plugin
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Auto suggestion bundle
antigen bundle zsh-users/zsh-autosuggestions


# Auto pair
antigen bundle hlissner/zsh-autopair

# Syntax highlighting bundle. ((should be last))
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
# antigen theme robbyrussell
antigen theme romkatv/powerlevel10k
# eval "$(oh-my-posh init zsh --config ~/Downloads/blueish.omp.json)"

# Tell Antigen that you're done.
antigen apply

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# autosuggestions color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow,bg=black,bold,underline"
source /home/zinis/.local/dracula-highlight.sh

show_colors() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

down() {
  echo "aria2c -s 10 -x 10 -k 1M \"$1\""
  aria2c -s 10 -x 10 -k 1M "$1"
}

yt-best() {
  echo "yt-dlp -f bestvideo+bestaudio \"$1\""
  yt-dlp -f bestvideo+bestaudio "$1"
}

yt-audio() {
  echo "yt-dlp -f bestaudio --extract-audio --audio-format mp3 \"$1\""
  yt-dlp -f bestaudio --extract-audio --audio-format mp3 "$1"
}

obsidian-sync() {
  bash ~/obsidian_vault/.obsidian/sync.sh
}

datetime-sync(){
  echo "Syncing time with NTP server"
  sudo systemctl stop ntpd
  sudo ntpdate 0.us.pool.ntp.org
  sudo systemctl start ntpd
  echo "Time synced with NTP server"
}

# apply dark colorscheme after package updates
colorscheme-hammer-fix(){
  cd /usr/share/color-schemes
  echo creating backup
  sudo cp BreezeLight.colors BreezeLight.colors.bak
  echo enforcing dark mode
  sudo cp BreezeDark.colors BreezeLight.colors
  cd ~
}

# own the code directory to apply custom css and js
code-chown(){
  echo "changing ownership of code"
  sudo chown -R $(whoami) "$(which code)"
  sudo chown -R $(whoami) /opt/visual-studio-code
}

alias yay='yay --sudoloop --batchinstall'
alias fastfetch='fastfetch -l windows'
alias about='~/playground/CP/about.sh'
# alias ssh='kitty +kitten ssh'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/zinis/.local/override/cli/google-cloud-sdk/path.zsh.inc' ]; then . '/home/zinis/.local/override/cli/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/zinis/.local/override/cli/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/zinis/.local/override/cli/google-cloud-sdk/completion.zsh.inc'; fi

bindkey '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# fzf init
# source <(fzf --zsh)
# HISTFILE=~/.zsh_history
# HISTSIZE=10000
# SAVEHIST=10000
# setopt appendhistory
# setopt hist_ignore_dups


# pnpm
export PNPM_HOME="/home/zinis/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
