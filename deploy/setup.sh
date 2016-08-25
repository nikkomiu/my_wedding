#!/bin/bash

# Set ENV variables if version tag or master branch
if [ -n "$CI_BUILD_TAG" ]
then
  echo "# PROD Deploy..."
  echo ""

  if [ -n "$PROD_DB_URL" ]; then
    echo "export DB_URL=$PROD_DB_URL"
  fi

  echo "export CLUSTER=\"production\""
  echo ""

elif [ "$CI_BUILD_REF_NAME" = "master" ]
then
  echo "# STAGE Deploy..."
  echo ""

  if [ -n "$STAGE_DB_URL" ]; then
    echo "export DB_URL=$STAGE_DB_URL"
  fi

  echo "export CLUSTER=\"staging\""
  echo ""

else
  echo "# CI Build ENV not set!"
  echo "# Make sure the ENV variable CI_BUILD_REF_NAME exists"
  exit -1
fi

echo "# Run this command to configure your shell:"
echo "# eval \"\$(./deploy_setup.sh)\""
