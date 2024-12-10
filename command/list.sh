help_list_command() {
  io_comment 'Description:'
  io_line "  Display help for a command"
  io_line

  io_comment 'Usage:'
  io_line '  help [options] [--] [<command_name>]'
  io_line

  io_comment 'Arguments:'
  io_line '  <success>command_name</success>   The command name <comment>[default: "list"]</comment>'
  io_line

  io_comment 'Options:'
  io_line '  <success>-h, --help</success>     Display help for the given command. When no command is given, display help for the <success>list</success> command'
  io_line '  <success>-V, --version</success>  Display this application version'
  io_line

  io_comment 'Help:'
  io_line '  The <success>help</success> command displays help for a given command:'
  io_line
  io_line '    <success>butlersh help list</success>'

  exit 0
}

run_list_command() {
  io_line "<success>Butlersh</success> version <comment>dev-main</comment>"
  io_line

  io_comment 'Usage:'
  io_line "  command [options] [arguments]"
  io_line

  io_comment "Options:"
  io_line '  <success>-h, --help</success>      Display help for the given command. When no command is given, display help for the <success>list</success> command'
  io_line '  <success>-V, --version</success>   Display this application version'
  io_line

  io_comment "Available commands:"
  io_line '  <success>list</success>            List commands'
  io_comment ' mysql'
  io_line '  <success>mysql:setup</success>     Set up MySQL for the current server'
  io_comment ' nginx'
  io_line '  <success>nginx:setup</success>     Set up Nginx for the current server'
  io_comment ' php'
  io_line '  <success>php:setup</success>       Set up PHP for the current server'
  io_comment ' security'
  io_line '  <success>security:setup</success>  Set up security for the current server'
}
