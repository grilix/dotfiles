if [ -z $INSTALL_PATH ]; then
  echo "You are doing it wrong!"
  echo "Don't call this directly! Use ../install.sh"
  exit -1
fi

inject_line ~/.bashrc ". '$CURRENT_MODULE_PATH/bashrc'"