# splits i/o
splits i/o is a website similar to Pastebin or GitHub Gist, but for splits generated from speedruns rather than text or
code. It's written in Ruby on Rails.

splits i/o currently supports splits from Urn, LiveSplit, SplitterZ, Time Split Tracker, and WSplit.

## Running locally

### Requirements
* Ruby 2.2.2
* PostgreSQL

### First run
```bash
cp config/application.example.yml config/application.yml
$EDITOR config/application.yml # give it a once-over (required if you want local sign in)
bundle install
rake db:create db:migrate
rails server
```

You must also run a [fakes3][fakes3] server in another terminal window. This is to receive and store raw uploaded splits
for parsing.
```bash
fakes3 -r /tmp -p 4567
```
You're good to go! Access [localhost:3000][localhost] in your browser.

[fakes3]: https://github.com/jubos/fake-s3
[localhost]: http://localhost:3000/

#### Troubleshooting (OS X)

If you get Bundler errors about `eventmachine`, try

```bash
brew install openssl
brew link openssl --force
```

If that doesn't work, you may need to also run

```bash
gem install eventmachine -- --with-cppflags=-I/usr/local/opt/openssl/include
```

If you get Bundler errors about `nokogiri`, run

```bash
xcode-select --install
```

## API
See the full API documentation in the [API readme](./docs/api.md) file.

## Parsing
If you're interested in how we parse run files from different programs, check out the [parsing
readme](./docs/parsing.md).

## Tests
To start running tests, you'll need to set up a test database:

```bash
RAILS_ENV=test rake db:create db:migrate
```
