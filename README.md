<p align="center">
  <a href="https://splits.io/" rel="noopener">
    <img src="https://i.imgur.com/PoeNer0.jpg" />
  </a>
</p>

<h3 align="center">Splits.io</h3>

<p align="center">

  [![View performance data on Skylight](https://badges.skylight.io/typical/l4aQWIYa50pX.svg)](https://oss.skylight.io/app/applications/l4aQWIYa50pX)
  [![View performance data on Skylight](https://badges.skylight.io/problem/l4aQWIYa50pX.svg)](https://oss.skylight.io/app/applications/l4aQWIYa50pX)
  [![View performance data on Skylight](https://badges.skylight.io/rpm/l4aQWIYa50pX.svg)](https://oss.skylight.io/app/applications/l4aQWIYa50pX)
  [![License](https://img.shields.io/github/license/glacials/splits-io.svg)](/LICENSE)

</p>

---

<p align="center">
  A speedrun data store and analysis engine.
</p>

## About
Splits.io is how speedrunners improve through data. It gives split-by-split analysis of individual runs, viewed through a
lens of all runs. On Splits.io, speedrunners share more than their time -- they share their entire history of attempts, successful
or not, and get feedback on how to improve long-term through statistics and comparisons with themselves and other runners in their
weight class.

Splits.io works with LiveSplit and more than 15 other speedrunning timers. An auto-generated list
can be viewed in the [FAQ][faq]; new timers can self-integrate using the [Splits.io Exchange Format][exchange].

[exchange]: /public/schema
[faq]: https://splits.io/faq#programs

## API
For full API documentation, see the [API readme][api-docs].

[api-docs]: /docs/api.md

## Local Development
Splits.io runs on Docker, which makes it easy and consistent to set up and run on any machine despite any unusual
dependencies. The one downside is that you must first install Docker!

### Requirements
* [Docker][docker-download]
* [Docker Compose][docker-compose-download] (Mac and Windows include this in the Docker install)

[docker-download]: https://store.docker.com/search?type=edition&offering=community
[docker-compose-download]: https://docs.docker.com/compose/install/

### First Run
The first time you run Splits.io with Docker is the best, because you'll have time to get a coffee! Yum! After the
first run, it will be much quicker.
```sh
make
```
Once the output looks settled (you should see `* Listening on tcp://0.0.0.0:3000`), you're good to go! Access
[localhost:3000][localhost] in your browser. The first page load after a new build may also take a minute.

[localhost]: http://localhost:3000/

#### Optional Features
Some features are built on top of links with other platforms, like Twitch sign-in. If you want these features to work,
you need to register developer applications with the appropriate services. See `.envrc.example` for details on which
features require which platforms.

After changing or creating `.envrc`, run
```sh
source .envrc && make build run
```
to rebuild the server with your new environment variables, or use [direnv][direnv] to automate this step!

[direnv]: https://github.com/direnv/direnv

### Debugging
#### Getting Up and Running
If you're having trouble getting Splits.io running at all using the above instructions, please make a GitHub issue so
we can work it out! Even if you think it's a silly issue, the fact that it's happening to you means we haven't ironed
out everything (even if the only thing preventing you from setting up is better documentation!).

#### Working with the Code
If you have the app up and running but are looking for insight into debugging your own changes, you can access a Rails
console inside the Docker container with
```sh
make console
```

#### Attaching to a debugger
If you use `binding.pry` anywhere in the code, once you hit the breakpoint specified use the command
```sh
make attach
```
in another terminal window to attach to it.  To detach, make sure to exit the debug session then use the docker
attach escape sequence `ctrl + p` then `ctrl + q`.

If you need to attach to a container other than `web`, specify a container with the syntax
```sh
make attach container=worker
```

### Running Tests
To run tests from inside the Docker container, use
```sh
make test
```
To run only specific tests, use
```sh
make test path=spec/path/to/test/file/or/dir
```

### Linting
We use [Rubocop][rubocop] for code cleanliness and styling. To run it against changed files, commit your changes and run
```sh
make lint
```

### Profiling
Splits.io utilizes a few libraries for profiling our code.


[Rack Mini Profiler](https://github.com/MiniProfiler/rack-mini-profiler) is used to find major slowdowns in the code
through the use of the badge in the top left corner of the browser window. There is also a slew of different URL
paremeters that you can use to get more detailed information about various aspects of the request. Details of these are
explained in the readme for RMP.
To get more detailed information about how code will perform in a production like environment, run
```sh
make profile
```
to boot the app in the profiling environment, which has most of the production flags toggled on.


[DerailedBenchmarks](https://github.com/schneems/derailed_benchmarks) is used to test memory over lots of requests.
The commands that can be run are detailed in the readme for DB. When you have a command you want to run, use the make
task like so with the options that you need
```sh
make derailed env="-e TEST_COUNT=5000 -e USE_AUTH=true" command="exec perf:mem_over_time"
```
The env flag is optional, so feel free to leave that blank if you have no environment variables to set.

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
which will run `docker-compose down`, remove the bundler volume, and remove `node_modules/`.

## Things You Probably Don't Need to Know
### Infrastructure
Splits.io is built in Ruby on Rails, but has some help from other pieces of infrastructure.
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

[docker-compose.yml]: docker-compose.yml

### Favicons
Favicons are generated by [Favicon Generator][favicon-generator] and its Rails gem. To generate favicons from the source
image ([public/logo-imageonly.svg][logo]), run
```sh
docker-compose run web rails generate favicon
```
Config for this generation is at [`config/favicon.json`][favicon-config].

[favicon-generator]: https://realfavicongenerator.net/
[logo]: app/assets/images/logo-imageonly.svg
[favicon-config]: config/favicon.json

### Theme
Splits.io runs [Bootstrap 4][bootstrap] on a paid theme called [Dashboard][dashboard]. Its license does not allow its
unminified source to be included in this repository; for posterity there are three modifications we make to the source
before producing the included final build. This is within the terms of the license.

- In `/v4/scss/variables.scss`:
	- Change `$theme-colors[primary]` to `#489BE7`
	- Change `$theme-colors[success]` to `#6EE588`
	- Change `$theme-colors[warning]` to `#F5BA46`

These new colors match those in the Splits.io logo.

[bootstrap]: https://getbootstrap.com/
[dashboard]: https://themes.getbootstrap.com/product/dashboard/

## Responsible Disclosure
If you find a security vulnerability in Splits.io, please email it to security@splits.io, as posting the vulnerability
in public may allow malicious people to use it before it's able to be fixed.

## Library Information
### LiveSplit Core
Splits.io uses [livesplit-core][livesplit-core] for parsing runs. The parser is located in `lib/parser/*`. To upgrade
it, run
```sh
make update_lsc
```
and commit the changes.

[livesplit-core]: https://github.com/LiveSplit/livesplit-core/

### Highcharts
To generate run history charts Splits.io uses [Highcharts][highcharts-home], which requires a
[written license][highcharts-licenses]. Licensing is based on the honor system, so you do not need to enter a key
anywhere. Highcharts is free to use for testing purposes.

[highcharts-home]: https://www.highcharts.com/
[highcharts-licenses]: https://shop.highsoft.com/highcharts
