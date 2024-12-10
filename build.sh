#!/usr/bin/env bash

CLI_NAME='butlersh'

rm -f $CLI_NAME

echo '#!/usr/bin/env bash' > "$CLI_NAME"

# Prepare lib functions
for LIB_NAME in check io version
do
  cat lib/$LIB_NAME.sh >> "$CLI_NAME"
done

# Prepare script functions
for SCRIPT_NAME in mysql-setup nginx-setup php-setup security-setup
do
  cat "scripts/$SCRIPT_NAME.sh" >> "$CLI_NAME"
done

# Prepare command functions
cat commands/list.sh >> "$CLI_NAME"

cat server-cli.sh >> "$CLI_NAME"

chmod +x "$CLI_NAME"
