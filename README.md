# Splits I/O
Splits I/O is a website similar to Pastebin or GitHub Gist, but for splits generated from speedruns rather than text or
code. It's written in Ruby on Rails.

Splits I/O currently supports splits from Urn, LiveSplit, SplitterZ, Time Split Tracker, and WSplit.

## API
For full API documentation, see the [API readme][api-docs].

[api-docs]: ./docs/api.md

## Running locally
Splits I/O runs on Docker, which makes it easy and consistent to set up and run on any machine despite any unusual
dependencies. The one downside is that you must first install Docker!

### Requirements
* [Docker][docker-download]
* [Docker Compose][docker-compose-download] (Mac and Windows include this in the Docker install)

[docker-download]: https://www.docker.com/community-edition#/download
[docker-compose-download]: https://docs.docker.com/compose/install/

### First run
The first time you run Splits I/O with Docker is the best, because you'll have time to get a coffee! Yum! After the
first run, it will be much quicker.
```sh
docker-compose up
```
Once the output looks settled, you're good to go! Access [localhost:3000][localhost] in your browser.

[localhost]: http://localhost:3000/

#### Accounts (optional)
Splits I/O accounts are built on top of Twitch accounts, so if you want sign up / sign in to work, you will need to
register a Twitch application at [twitch.tv/settings/connections][twitch.tv/settings/connections]. Use this redirect URI
when asked:
```http
http://localhost:3000/auth/twitch/callback
```
Twitch will give you a client ID and a client secret. Open `Dockerfile` and find the spots to fill in. Then run
```sh
git update-index --skip-worktree Dockerfile # to avoid accidentally committing your changes
docker-compose build
```
before starting the server again and you're set!

### Debugging
#### Getting up and running
If you're having trouble getting Splits I/O running at all using the above instructions, please make a GitHub issue so
we can work it out! Even if you think it's a silly issue, the fact that it's happening to you means we haven't ironed
out everything (even if the only thing preventing you from setting up is better documentation!).

#### Working with the code
If you have the app up and running but are looking for insight into debugging your own changes, you can access a Rails
console with
```sh
docker-compose run web rails console
```

### Running tests
To run tests, use
```sh
docker-compose run -e "RAILS_ENV=test" web rspec
```

### Updating gems or Docker
If you change the Dockerfile or Gemfile, you'll need to run
```sh
docker-compose build
```
to rebuild the Docker image for your changes to apply.

## Parsing
If you're interested in how we parse run files from different programs, check out the [parsing
readme](./docs/parsing.md).
