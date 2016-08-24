#!/bin/bash

# Run Migrations for Environment
sed -i "s/\${DB_HOST}/$DB_HOST/g" config/prod.exs
sed -i "s/\${DB_PASS}/$DB_PASS/g" config/prod.exs
MIX_ENV=prod mix ecto.migrate
