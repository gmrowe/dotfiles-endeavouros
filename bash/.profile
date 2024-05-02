#
# ~/.bash_profile
#

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Set environment variables  to conform to XDG_Base_Directory specification
# See: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_DATA_DIRS=/usr/local/share/:/usr/share/
export XDG_CONFIG_DIRS=/etc/xdg

# Use shell version of emacs as my default editor
export VISUAL='emacsclient -nw'

# Define RUSTUP_HOME in relation to XDG_DATA_HOME
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
# Define CARGO_HOME in relation to XDG_DATA_HOME
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# Define GNUPGHOME in relation to XDG_DATA_HOME
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# Define `pass` directory in terms of XDG_DATA_HOME
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
