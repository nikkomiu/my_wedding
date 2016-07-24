export MIX_ENV=prod

release: app assets
	mix release

install:
	mix local.hex --force
	mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force
	npm install -g brunch
	npm install -g bower

assets:
	brunch b
	mix phoenix.digest

app: app-build

app-build:
	mix compile

deps: deps-get deps-compile

deps-get:
	mix deps.get
	npm install
	bower install --allow-root

deps-compile:
	mix deps.compile
