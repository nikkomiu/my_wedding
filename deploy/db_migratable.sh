#!/bin/bash

# Run DB Migrations
mix ecto.setup

# Checkout master
git checkout master

# Test app
mix test
