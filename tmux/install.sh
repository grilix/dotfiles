if [ -z $INSTALL_PATH ]; then
  echo "You are doing it wrong!"
  echo "Don't call this directly! Use ../install.sh"
  exit -1
fi

create_dir ".tmux"

git_clone "https://github.com/tmux-plugins/tpm" ".tmux/plugins/tpm"

link_file "tmux.conf" ".tmux.conf"
