#!/usr/bin/env bash

declare -x DEBUG="1"
declare -x PRETEND="0"
declare -x FORCE="0"
declare -x BACKUP="1"
declare -x SOURCE_PATH="`pwd`"
declare -x INSTALL_PATH="`echo ~`"
declare -x CURRENT_MODULE_PATH="$SOURCE_PATH"

print_flag() { flag="$1"; expected="$2"; text="$3"
  echo -n "  "
  if [ "$flag" = "$expected" ]; then
    echo -n "*"
  else
    echo -n " "
  fi

  echo " $text"
}

usage() {
  echo "Usage:"
  echo "  $0 [OPTIONS] [MODULE]"
  echo
  echo "  OPTIONS: (* -> active)"
  print_flag "$FORCE" "1" \
           "-f|--force     Overwrite files."
  print_flag "$FORCE" "0" \
           "-n|--safe      Nevermind, don't overwrite things."
  print_flag "$PRETEND" "1" \
           "-p|--pretend   Don't touch anything at all."
  print_flag "$BACKUP" "0" \
           "-B|--no-backup Don't backup changed files."
  print_flag "$BACKUP" "1" \
           "-b|--backup    Nevermind, do backups."
  print_flag "$DEBUG" "0" \
           "-s|--silent    Try to not make noise."
  print_flag "$DEBUG" "1" \
           "-d|--debug     Nevermind, make noise."
  echo "    -h|--help      Display this message."
  echo "    --path [PATH]  Set installation path (current: '$INSTALL_PATH')."
}

error() { message="$1"
  echo "$message" >&2
  exit -1
}
export -f error

debug() { message="$@"
  if [ "$DEBUG" = "1" ]; then
    echo " >> $message" >&2
  fi
}
export -f debug

pretend() {
  if [ -n "$1" ]; then
    debug "$@"
  fi

  [ "$PRETEND" = "1" ]
}
export -f pretend

forced() {
  if [ "$FORCE" = "1" ]; then
    [ -n "$1" ] && $@

    true
  else
    false
  fi
}
export -f forced

delete_link_if_broken() { destination="$1"
  if [ ! -e "$INSTALL_PATH/$original"  -a -L "$INSTALL_PATH/$original" ]; then
    cmd rm "$INSTALL_PATH/$original"
  fi
}
export -f delete_link_if_broken

backup() { original="$1"
  if [ "$BACKUP" = "0" ]; then
    return
  fi

  if [ ! -e "$INSTALL_PATH/$original" ]; then
    return
  fi

  delete_link_if_broken "$original"

  if [ -f "$INSTALL_PATH/$original.old" ]; then
    forced cmd rm "$INSTALL_PATH/$original.old" ||
      error "Cannot create backup $INSTALL_PATH/$original.old: Already exists."
  fi

  cmd cp "$INSTALL_PATH/$original" "$INSTALL_PATH/$original.old"
}
export -f backup

git_clone() { url="$1"; destination="$2"
  if [ -d "$INSTALL_PATH/$destination" ]; then
    cmd git --git-dir="$INSTALL_PATH/$destination/.git" pull

    return
  fi

  cmd git clone "$url" "$INSTALL_PATH/$destination"
}
export -f git_clone

link_file() { src=$1; destination=$2
  if [ "$CURRENT_MODULE_PATH/$src" -ef "$INSTALL_PATH/$destination" ]; then
    forced || return
  fi

  [ -e "$CURRENT_MODULE_PATH/$src" ] ||
    error "Source file $CURRENT_MODULE_PATH/$src exists"

  backup "$destination"

  cmd ln -fs "$CURRENT_MODULE_PATH/$src" "$INSTALL_PATH/$destination"
}
export -f link_file

inject_line() { file_path=$1; line=$2
  if [ -e "$INSTALL_PATH/$file_path" ]; then
    if grep "$line" "$INSTALL_PATH/$file_path" > /dev/null; then
      debug "Skipping change to $INSTALL_PATH/$file_path."
      return
    fi
  fi

  pretend "RUN: echo $line >> $INSTALL_PATH/$file_path" || {
    echo "$line" >> "$INSTALL_PATH/$file_path"
  }
}
export -f inject_line

cmd() {
  pretend "RUN: $@" || {
    if [ "$DEBUG" = "0" ]; then
      "$@" > /dev/null
    else
      "$@"
    fi
  }
}
export -f cmd

create_dir() { path="$1"
  [ -d "$INSTALL_PATH/$path" ] ||
    cmd mkdir -p "$INSTALL_PATH/$path"
}
export -f create_dir

install_module() { module="$1"
  [ ! -f "$module/install.sh" ] &&
    error "Invalid module: $module"

  CURRENT_MODULE_PATH="$SOURCE_PATH/$module"
  bash "$module/install.sh"
  CURRENT_MODULE_PATH="$SOURCE_PATH"
}

CUSTOM_MODULES="0"

while :
do
  case "$1" in
  -f|--force)     FORCE="1" ;;
  -n|--safe)      FORCE="0" ;;
  -p|--pretend)   PRETEND="1" ;;
  -B|--no-backup) BACKUP="0" ;;
  -b|--backup)    BACKUP="1" ;;
  -s|--silent)    DEBUG="0" ;;
  -d|--debug)     DEBUG="1" ;;
  -h|--help)      usage; exit ;;
  --path)
    shift
    INSTALL_PATH="$1"
    ;;
  -*)
    echo -e "Invalid argument: $1\n"
    usage
    exit -1
    ;;
  "") break;;
  *)
    CUSTOM_MODULES="1"
    install_module $1
    ;;
  esac

  shift
done

if [ "$CUSTOM_MODULES" = "0" ]; then
  install_module "vim"
  install_module "git"
  install_module "bash"
  install_module "tmux"
fi
