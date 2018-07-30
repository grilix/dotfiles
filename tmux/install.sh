create_dir ".tmux"

git_clone "https://github.com/tmux-plugins/tpm" ".tmux/plugins/tpm"
# Additionally, install plugins after clone:
#   ~/.tmux/plugins/tpm/bin/install_plugins

inject_line ".tmux.conf" "source-file $CURRENT_MODULE_PATH/tmux.colors.conf"
inject_line ".tmux.conf" "source-file $CURRENT_MODULE_PATH/tmux.conf"

bundle_bash
