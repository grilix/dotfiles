create_dir "local/scripts"

inject_line ".bashrc" "export PATH=\"$CURRENT_MODULE_PATH/bin:\$PATH\""
