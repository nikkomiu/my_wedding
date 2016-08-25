#!/bin/bash

if [ -z "$DB_URL" ]; then
  DB_URL="ecto://$DB_USER:$DB_PASS@$DB_HOST/$DB_BASE"
fi

./bin/my_wedding foreground
