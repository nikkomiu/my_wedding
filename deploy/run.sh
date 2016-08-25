#!/bin/bash

DB_URL="ecto://$DB_USER:$DB_PASS@$DB_HOST/$DB_BASE"

./bin/my_wedding foreground
