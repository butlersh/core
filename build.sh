#!/usr/bin/env bash

CLI_NAME='butlersh'

rm -rf $CLI_NAME

echo '#!/usr/bin/env bash' > "$CLI_NAME"

# Prepare libs
for LIB_NAME in check io version
do
  cat lib/$LIB_NAME.sh >> "$CLI_NAME"
done

# Prepare commands
for COMMAND_NAME in list mysql-setup nginx-setup php-setup security-setup
do
  cat "command/$COMMAND_NAME.sh" >> "$CLI_NAME"
done

cat main.sh >> "$CLI_NAME"

chmod +x "$CLI_NAME"
