if [ -z $INSTALL_PATH ]; then
  echo "You are doing it wrong!"
  echo "Don't call this directly! Use ../install.sh"
  exit -1
fi

create_dir ".vim/bundle"

git_clone "https://github.com/gmarik/Vundle.vim.git" ".vim/bundle/Vundle.vim"

link_file "vim/vimrc" ".vimrc"
link_file "vim/gvimrc" ".gvimrc"

cmd vim -e -c "set more" -S "$SOURCE_PATH/vim/bootstrap.vim"
