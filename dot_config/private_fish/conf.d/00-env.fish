set -gx XDG_CONFIG_DIR "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx EDITOR nvim
set -gx VISUAL nvim

set -g fish_history_limit 10000

set -gx VOLTA_HOME "$XDG_CONFIG_DIR/volta"
