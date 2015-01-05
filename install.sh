#!/usr/bin/env bash
FILES=".vimrc .gvimrc"
DIR="`pwd`"
INSTALL_PATH="`echo ~`"

error() { message=$1
  echo $message
  exit -1
}

backup() { original=$1
  if [ -f "$original.old" ]; then
    error "Cannot backup $original: $original.old already exists."
  fi
  mv "$original"{,.old}
}

git_clone() { url=$1; destination=$2
  if [ -d $destination ]; then
    echo " (Skipping $url)"
  else
    git clone $url $destination
  fi
}

link_file() { src=$1; destination=$2
  if [ -L "$destination" ]; then
    echo " >> SKIP $destination"
    return
  fi
  if [ -e "$destination" ]; then
    backup "$destination"
  fi
  echo " >> LINK: $destination -> $src"
  ln -s "$src" "$destination"
}

## Install Vundle
git_clone "https://github.com/gmarik/Vundle.vim.git" "$INSTALL_PATH/.vim/bundle/Vundle.vim"

for dotfile in $FILES; do
  link_file "$DIR/$dotfile" "$INSTALL_PATH/$dotfile"
done

# Bootstrap vim
vim -e -c "set more" -S bootstrap.vim

