# splits i/o
splits i/o is a website similar to Pastebin or GitHub Gist, but for splits generated from speedruns rather than text or
code. It's written in Ruby on Rails.

splits i/o currently supports splits from Urn, LiveSplit, SplitterZ, Time Split Tracker, and WSplit.

## Running locally

### Requirements
* Ruby 2.3.1
* PostgreSQL

### First run
```bash
cp config/application.example.yml config/application.yml
$EDITOR config/application.yml # give it a once-over (required if you want local sign in)
bundle install
rake db:create db:migrate
rails server
```

Splits I/O runs using some AWS resources, which means to run it locally you'll have to use local versions of these
resources (or have AWS account credentials specified in `config/application.yml`).

#### S3
Splits I/O uses AWS S3 for long-term run file storage. S3 is the source of truth for run files, allowing us to reparse
runs whenever as if the run was just uploaded for the first time. To shim S3 on your local machine, run a
[fakes3][fakes3] server in another terminal window.
```bash
fakes3 -r /tmp -p 4567
```

[fakes3]: https://github.com/jubos/fake-s3

#### DynamoDB
Splits I/O uses AWS DynamoDB for storing parsed runs, so that we don't have to reparse huge 10MB runs to get the splits
out of it every time we want to display them. Everything in DynamoDB can theoretically be recreated from what's stored
in S3.

To shim DynamoDB on your local machine, run Amazon's official [DynamoDB local][dynamodb-local]. If you're on MacOS, you
can install this with just
```bash
brew install dynamodb-local
```
then have it auto-run now and at boot with
```bash
brew services start dynamodb-local
```

[dynamodb-local]: http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html

#### In your browser
You're good to go! Access [localhost:3000][localhost] in your browser.

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
