export B_VERSION=${env:-dev-main}

display_version() {
  echo -e "\e[32mButlersh\e[0m version \e[33m$B_VERSION\e[0m"
}
