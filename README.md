#Boardgame Recommender

This is an Angular/Rails app designed to help you choose boardgames.

It uses the Board Game Geek XML API for board game details both when adding games individually, and when importing a user's collection. These games are then added to the app's own database.
Games to play (already in the user's 'cupboard') or buy (not in the user's 'cupboard') are recommended from the app's database based on selected criteria - player number, mechanics and genres.

Live demo [here](https://boardgame-recommender.herokuapp.com).

To spin a local version (assuming bower, ruby and rails, postgresql are already installed):

```
git clone https://github.com/tealpaintedduck/boardgame_cupboard
cd boardgame_cupboard
bower install
rails s
```
and navigate to localhost:3000


###N.B.

The Board Game Geek API has some questionable (undocumented) rate limits and dislikes AWS (and therefore Heroku). I'm currently using a proxy to avoid the AWS issue on the live demo but if the API calls aren't working, it'll be due to this. Please let me know if this happens! If you're cloning it down, it won't use the proxy and should be ok for mild use.

###Tests

Feature tested with Rspec, using VCR & Webmock for API calls.

To run tests:

```
rspec
```