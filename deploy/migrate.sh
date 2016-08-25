#!/bin/bash

# Run Migrations for Environment
if [ -n $DB_HOST ]; then
  sed -i "s/\${DB_HOST}/$DB_HOST/g" config/prod.exs
else
  sed -i "s/\${DB_HOST}/192.168.99.100/g"
fi

if [ -n $DB_PORT ]; then
  sed -i "s/port: 5432/port: $DB_PORT/g" config/prod.exs
fi

if [ -n $DB_PASS ]; then
  sed -i "s/\${DB_PASS}/$DB_PASS/g" config/prod.exs
else
  sed -i "s/\${DB_PASS}/somepassword/g"
fi

if [ -n $DB_PORT ]; then
  sed -i "s/\${DB_PASS}/$DB_BASE/g" config/prod.exs
else
  sed -i "s/\${DB_PASS}/my_wedding_prod/g"
fi

MIX_ENV=prod mix ecto.migrate
