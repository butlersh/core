#!/usr/bin/env bash

CLI_NAME='butlersh'

rm -f $CLI_NAME

echo '#!/usr/bin/env bash' > "$CLI_NAME"
cat lib/check.sh >> "$CLI_NAME"
cat lib/version.sh >> "$CLI_NAME"
for SCRIPT_NAME in mysql-setup nginx-setup php-setup security-setup
do
  cat "scripts/$SCRIPT_NAME.sh" >> "$CLI_NAME"
done
cat server-cli.sh >> "$CLI_NAME"

chmod +x "$CLI_NAME"
