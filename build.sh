#!/usr/bin/env bash

for SCRIPT_NAME in security-setup mysql-setup nginx-setup php-setup
do
  echo '#!/usr/bin/env bash' > scripts/$SCRIPT_NAME.sh
  cat lib/check.sh >> scripts/$SCRIPT_NAME.sh
  cat lib/version.sh >> scripts/$SCRIPT_NAME.sh
  cat src/$SCRIPT_NAME.sh >> scripts/$SCRIPT_NAME.sh
done

chmod +x scripts/*.sh
