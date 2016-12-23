# Install Packages
install:
	mix local.hex --force
	mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force
	npm install -g brunch bower

# Get and build assets
assets: fetch-assets
	brunch b --production
	mix phoenix.digest

fetch-assets:
	npm install
	bower install --allow-root
