#!/bin/bash

# Set some ENV variables based on branch
if [ "$CI_BUILD_REF_NAME" = "master" ]
then
  echo "PROD Deploy..."

  DB_HOST=$PROD_DB_HOST
  DB_PASS=$PROD_DB_PASS
  CLUSTER="production"

elif [ "$CI_BUILD_REF_NAME" = "develop" ]
then
  echo "STAGE Deploy..."

  DB_HOST=$STAGE_DB_HOST
  DB_PASS=$STAGE_DB_PASS
  CLUSTER="staging"

else
  echo "CI Build ENV not set!"
  exit -1
fi

# Run Migrations for Environment
sed -i "s/\${DB_HOST}/$DB_HOST/g" config/prod.exs
sed -i "s/\${DB_PASS}/$DB_PASS/g" config/prod.exs
MIX_ENV=prod mix ecto.migrate

# Trigger the deployment project
curl -X POST \
     -F token=$DEPLOY_TRIGGER_TOKEN \
     -F ref=master \
     -F variables[CLUSTER]=$CLUSTER \
     https://gitlab.com/api/v3/projects/1473961/trigger/builds
