source ~/.config/fish/user_variables.fish
source ~/.config/fish/abbreviations.fish
set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
starship init fish | source

fish_add_path /home/egor/.spicetify
