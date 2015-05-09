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
rails server
```

## API
See the full API documentation in the [API readme](./docs/api.md) file.

## Parsing
If you're interested in how we parse run files from different programs, check out the [parsing
readme](./docs/parsing.md).

[1]: https://github.com/laserlemon/figaro
