#!/usr/bin/env bash

DEBUG="1"
PRETEND="0"
FORCE="0"
BACKUP="1"

usage() {
  echo "Usage:"
  echo "  $0 [OPTIONS]"
  echo
  echo "  OPTIONS: (* -> default)"
  echo "    -f|--force     Overwrite files."
  echo "    -p|--pretend   Don't touch anything at all."
  echo "    -B|--no-backup Don't backup changed files."
  echo "  * -b|--backup    Nevermind, do backups."
  echo "    -s|--silent    Try to not make noise."
  echo "  * -d|--debug     Nevermind, make noise."
  echo "    -h|--help      Display this message."
}


SOURCE_PATH="`pwd`"
INSTALL_PATH="`echo ~`"

error() { message="$1"
  echo "$message" >&2
  exit -1
}

debug() { message="$@"
  if [ "$DEBUG" = "1" ]; then
    echo " >> $message" >&2
  fi
}

pretend() {
  if [ -n "$1" ]; then
    debug "$@"
  fi

  [ "$PRETEND" = "1" ]
}

forced() {
  if [ "$FORCE" = "1" ]; then
    $@

    true
  else
    false
  fi
}

cmd() {
  pretend "RUN: $@" || {
    if [ "$DEBUG" = "0" ]; then
      $@ > /dev/null
    else
      $@
    fi
  }
}

create_dir() { path="$1"
  cmd mkdir -p "$INSTALL_PATH/$path"
}

assert() { message="$1"; shift; condition="$@"
  if ! $condition; then
    error "ASSERTION FAILED: $message"
  fi
}

delete_link_if_broken() { destination="$1"
  if [ ! -e "$INSTALL_PATH/$original"  -a -L "$INSTALL_PATH/$original" ]; then
    cmd rm "$INSTALL_PATH/$original"
  fi
}

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

git_clone() { url="$1"; destination="$2"
  if [ -d "$INSTALL_PATH/$destination" ]; then
    cmd git --git-dir="$INSTALL_PATH/$destination/.git" pull

    return
  fi

  cmd git clone "$url" "$INSTALL_PATH/$destination"
}

link_file() { src=$1; destination=$2
  if [ "$SOURCE_PATH/$src" -ef "$INSTALL_PATH/$destination" ]; then
    return
  fi

  assert "Source file $SOURCE_PATH/$src exists" [ -e "$SOURCE_PATH/$src" ]

  backup "$destination"

  cmd ln -fs "$SOURCE_PATH/$src" "$INSTALL_PATH/$destination"
}

while :
do
  case "$1" in
  -f|--force)     FORCE="1" ;;
  -p|--pretend)   PRETEND="1" ;;
  -B|--no-backup) BACKUP="0" ;;
  -b|--backup)    BACKUP="1" ;;
  -s|--silent)    DEBUG="0" ;;
  -d|--debug)     DEBUG="1" ;;
  -h|--help)      usage ;;
  -*)
    echo -e "Invalid argument: $1\n"
    usage
    exit -1
    ;;
  *) break;;
  esac

  shift
done

debug   "DEBUG MODE"
pretend "" &&
  debug "PRETEND MODE" ||
  debug "INSTALL MODE"
forced \
  debug "FORCE MODE"

. "$SOURCE_PATH/vim/install.sh"
. "$SOURCE_PATH/git/install.sh"
