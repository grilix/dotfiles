create_dir ".vim/bundle"

git_clone "https://github.com/gmarik/Vundle.vim.git" ".vim/bundle/Vundle.vim"

inject_line ".vimrc" "source $CURRENT_MODULE_PATH/vimrc"
link_file "gvimrc" ".gvimrc"

cmd vim -e -c "set more" -S "$CURRENT_MODULE_PATH/bootstrap.vim"
