
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1 is the prompt which runs before each bash command
# See: https://wiki.archlinux.org/title/Bash/Prompt_customization#Prompts
PS1='\u@\h:\w\$ '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias emacs='emacsclient -c -a ""'
alias open='xdg-open'
alias cat='bat'
alias calc='clac'
alias tree='tree -C'

# Add fzf keybinding scripts
eval "$(fzf --bash)"
