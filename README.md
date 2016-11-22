# My Wedding

[![build status](https://gitlab.com/nikko.miu/my_wedding/badges/master/build.svg)](https://gitlab.com/nikko.miu/my_wedding/commits/master)
[![coverage report](https://gitlab.com/nikko.miu/my_wedding/badges/master/coverage.svg)](https://gitlab.com/nikko.miu/my_wedding/commits/master)

## Setup

This is the setup guide it is recommended to read through this prior to setting up the
Kubernetes instances of the application up as well as any other method of hosting.

This is the basic set of instructions to get the application up and running.

### Database Initialization

The first thing that will need to be done is to create a database. The default name of the production
database for the application is `my_wedding_prod` and can be created using Ecto with the command
`mix ecto.create`.

After the database has been created the migrations need to be run. The migrations can be run with the
Ecto command `mix ecto.migrate`.

Finally, to finish the initial database setup the database seeds will need to be put in with the
command `mix run priv/repo/seeds.exs`.
