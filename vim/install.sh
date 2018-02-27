if [ -z $INSTALL_PATH ]; then
  echo "You are doing it wrong!"
  echo "Don't call this directly! Use ../install.sh"
  exit -1
fi

create_dir ".vim/bundle"

git_clone "https://github.com/gmarik/Vundle.vim.git" ".vim/bundle/Vundle.vim"

inject_line ".vimrc" "source $CURRENT_MODULE_PATH/vimrc"
link_file "gvimrc" ".gvimrc"

cmd vim -e -c "set more" -S "$CURRENT_MODULE_PATH/bootstrap.vim"
