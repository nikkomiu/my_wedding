# Compile app and build release
release: build assets
	mix release

# Install Packages
install:
	mix local.hex --force
	mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force
	npm install -g brunch bower

# Compile app
build: deps
	mix compile

# Get and build assets
assets: fetch-assets
	brunch b
	mix phoenix.digest

deps:
	mix deps.get

fetch-assets:
	npm install
	bower install --allow-root
