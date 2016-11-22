# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

MyWedding.Repo.insert!(%MyWedding.Album{
  title: "Post Photos",
  description: "The album for storing post photos.",
  is_public: false
})
