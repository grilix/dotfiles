create_dir ".tmux"

inject_line ".tmux.conf" "source-file $CURRENT_MODULE_PATH/tmux.colors.conf"
inject_line ".tmux.conf" "source-file $CURRENT_MODULE_PATH/tmux.conf"

# Additionally, install plugins after clone:
#   ~/.tmux/plugins/tpm/bin/install_plugins
inject_line ".tmux.conf" "run $CURRENT_MODULE_PATH/tpm/tpm"

bundle_bash
