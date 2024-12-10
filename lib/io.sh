io_line() {
  LINE=$(echo "$1" | sed 's/<success>/\\e[32m/g' | sed 's/<\/success>/\\e[0m/g' | sed 's/<comment>/\\e[33m/g' | sed 's/<\/comment>/\\e[0m/g')
  echo -e "$LINE"
}

io_success() {
  echo -e "\e[32m$1\e[0m"
}

io_comment() {
  echo -e "\e[33m$1\e[0m"
}

io_error() {
  echo -e "\e[31m$1\e[0m"
}
