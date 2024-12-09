export B_VERSION=${env:-dev-main}

display_version() {
  echo -e "\e[32mButlersh CLI\e[0m version \e[33m$B_VERSION\e[0m"
}
