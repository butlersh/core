export B_VERSION=${env:-dev-main}

display_version() {
  io_line "<success>Butlersh</success> version <comment>$B_VERSION</comment>"

  exit 0
}
