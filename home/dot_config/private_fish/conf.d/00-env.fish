# XDG DIR Settings
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
fish_add_path ~/.local/bin

# Fish Settings
set -g fish_history_limit 10000

# Npm Config
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx NPM_CONFIG_PREFIX "$XDG_DATA_HOME/npm"

# Node.js REPL 历史记录
set -gx NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"

set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
