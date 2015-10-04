if [ -z $INSTALL_PATH ]; then
  echo "You are doing it wrong!"
  echo "Don't call this directly! Use ../install.sh"
  exit -1
fi

link_file "gitignore" ".gitignore"
cmd git config --global --replace-all core.editor "vim -n +1"
cmd git config --global --replace-all push.default simple
cmd git config --global --replace-all color.ui true
