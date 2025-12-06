# Langauge
if set -q LC_ALL
    set -e LC_ALL
end
set -gx LANG zh_CN.UTF-8

# XDG DIR Settings
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# Default App
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BROWSER zen-browser

# Fish Settings
set -g fish_history_limit 10000

# Npm Config
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx NPM_CONFIG_PREFIX "$XDG_DATA_HOME/npm"

# Node.js REPL 历史记录
set -gx NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
