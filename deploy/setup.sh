#!/bin/bash

CI_BUILD_TAG="v1.1.1"

# Set ENV variables if version tag or master branch
if [[ "$CI_BUILD_TAG" == *stage ]]
then
  echo "# STAGE Deploy..."
  echo ""

  if [ -n "$STAGE_DB_URL" ]; then
    echo "export DB_URL=$STAGE_DB_URL"
  fi

  echo "export CLUSTER=\"staging\""
  echo ""

elif [[ "$CI_BUILD_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  echo "# PROD Deploy..."
  echo ""

  if [ -n "$PROD_DB_URL" ]; then
    echo "export DB_URL=$PROD_DB_URL"
  fi

  echo "export CLUSTER=\"production\""
  echo ""

elif [ -n "$CI_BUILD_TAG" ]
then
  echo "# Non-matching CI Build Tag!"
  echo "# Make sure Semantic versioning is followed."
  exit -1

else
  echo "# CI Build ENV not set!"
  echo "# Make sure the ENV variable CI_BUILD_TAG exists"
  exit -1
fi

echo "# Run this command to configure your shell:"
echo "# eval \"\$(./deploy_setup.sh)\""
