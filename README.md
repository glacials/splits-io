# Splits I/O
[![View performance data on Skylight](https://badges.skylight.io/typical/l4aQWIYa50pX.svg)](https://oss.skylight.io/app/applications/l4aQWIYa50pX)
[![View performance data on Skylight](https://badges.skylight.io/problem/l4aQWIYa50pX.svg)](https://oss.skylight.io/app/applications/l4aQWIYa50pX)
[![View performance data on Skylight](https://badges.skylight.io/rpm/l4aQWIYa50pX.svg)](https://oss.skylight.io/app/applications/l4aQWIYa50pX)

Splits I/O is a website similar to Pastebin or GitHub Gist, but for splits generated from speedruns rather than text or
code. It's written in Ruby on Rails.

Splits I/O currently supports splits from ShitSplit, Splitty, Llanfair2, FaceSplit, Portal2LiveTimer, LlanfairGered,
Llanfair, Urn, LiveSplit, SplitterZ, TimeSplitTracker, WSplit.

## API
For full API documentation, see the [API readme][api-docs].

[api-docs]: ./docs/api.md

## Local Development
Splits I/O runs on Docker, which makes it easy and consistent to set up and run on any machine despite any unusual
dependencies. The one downside is that you must first install Docker!

### Requirements
* [Docker][docker-download]
* [Docker Compose][docker-compose-download] (Mac and Windows include this in the Docker install)

[docker-download]: https://www.docker.com/community-edition#/download
[docker-compose-download]: https://docs.docker.com/compose/install/

### First Run
The first time you run Splits I/O with Docker is the best, because you'll have time to get a coffee! Yum! After the
first run, it will be much quicker.
```sh
make
```
Once the output looks settled, you're good to go! Access [localhost:3000][localhost] in your browser. The first page
load after a new build may also take a minute.

[localhost]: http://localhost:3000/

#### Accounts (Optional)
Splits I/O accounts are built on top of Twitch accounts, so if you want sign up / sign in to work, you will need to
register a Twitch application at [dev.twitch.tv/dashboard](https://dev.twitch.tv/dashboard).
Use this redirect URI when asked:
```http
http://localhost:3000/auth/twitch/callback
```
Twitch will give you a client ID and a client secret. Put them in `.env` in the same format as `.example.env`. Then run
```sh
source .env
make build
```
before starting the server again and you're set!

(If you want to do the source step automatically in the future, use something
like [`autoenv`](https://github.com/kennethreitz/autoenv).)

## Infrastructure
Splits I/O is built in Ruby on Rails, but has some help from other pieces of infrastructure:
```
Production

+---------------------------------------------------------------------------------+
| AWS Auto Scaling Group (usually at 1)                                           |
+---------------------------------------------------------------------------------+   +----------------+
| AWS Target Group                                                                |   | AWS RDS        |
| +--------------------------------------+ +------------------------------------+ |   | +------------+ |
| | AWS EC2 Instance                     | | AWS EC2 Instance                   | |-->| | PostgreSQL | |
| | +----------------------------------+ | | +--------------------------------+ | |   | +------------+ |
| | | Docker                           | | | | Docker                         | | |   +----------------+
| | | +------------------+ +-------+   | | | | +------------------+ +-------+ | | |
| | | | Rails (& worker) | | Redis |   | | | | | Rails (& worker) | | Redis | | | |-------------------------\
| | | +------------------+ +-------+   | | | | +------------------+ +-------+ | | |                         |
| | | | livesplit-core   |             | | | | | livesplit-core   |           | | |                         |
| | | +------------------+             | | | | +------------------+           | | |                         |
| | +----------------------------------+ | | +--------------------------------+ | |                         |
| +--------------------------------------+ +------------------------------------+ |       New file trigger  V
+---------------------------------------------------------------------------------+   +------------+ | +--------+
| AWS Application Load Balancer                                                   |<--| AWS Lambda |<--| AWS S3 |
+---------------------------------------------------------------------------------+ | +------------+   +--------+
                                       ^  |                      Lambda tells Rails to parse               ^
                                 HTTPS |  | WebSockets                                                     |
                                       |  V                                                                |
                                     +------+                                                              |
                                     | User |--------------------------------------------------------------/
                                     +------+        Upload run using presigned S3 POST from Rails
```
Rails will synchronously parse any unparsed run before rendering it, but the asynchronous Lambda job is the preferred
way for runs to be parsed because it still catches unvisited runs (e.g. in the case of a multi-file upload via
drag-and-drop).

In development PostgreSQL and S3 are also Docker containers (see [docker-compose.yml][docker-compose.yml]). Lambda is
not yet implemented in development mode.

### Debugging
#### Getting Up and Running
If you're having trouble getting Splits I/O running at all using the above instructions, please make a GitHub issue so
we can work it out! Even if you think it's a silly issue, the fact that it's happening to you means we haven't ironed
out everything (even if the only thing preventing you from setting up is better documentation!).

#### Working with the Code
If you have the app up and running but are looking for insight into debugging your own changes, you can access a Rails
console inside the Docker container with
```sh
make console
```

### Running Tests
To run tests from inside the Docker container, use
```sh
make test
```

### Linting
We use [Rubocop][rubocop] for code cleanliness and styling. To run it against changed files, commit your changes and run
```sh
make lint
```

[rubocop]: https://github.com/rubocop-hq/rubocop

### Updating Gems or Docker
If you change the Dockerfile or Gemfile, you'll need to run
```sh
make build
```
to rebuild the Docker image for your changes to apply.

### Cleaning Up
If you want to reset from scratch, you can run
```sh
make clean
```
which will run `docker-compose down`, resetting your local database and any Docker image builds.

## Library Information
### LiveSplit Core
Splits I/O uses [livesplit-core][livesplit-core] for parsing. The parser is located in `lib/parser/*`. To upgrade it,
run
```sh
make update_lsc
```
and commit the changes.

[livesplit-core]: https://github.com/LiveSplit/livesplit-core/

### Highcharts
To generate run history charts Splits I/O uses [Highcharts][highcharts-home], which requires a
[written license][highcharts-licenses]. Licensing is based on the honor system, so you do not need to enter a key
anywhere. Highcharts is free to use for testing purposes.

[highcharts-home]: https://www.highcharts.com/
[highcharts-licenses]: https://shop.highsoft.com/highcharts
