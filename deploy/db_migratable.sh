#!/bin/bash

# Run DB Migrations
mix ecto.create
mix ecto.migrate

git reset --hard

# TODO: If master then checkout latest tag else checkout master
# Checkout master
git checkout master

# Test app
mix test
