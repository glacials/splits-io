# splits i/o
splits i/o is a website similar to Pastebin or GitHub Gist, but for splits generated from speedruns rather than text or
code. It's written in Ruby on Rails.

splits i/o currently supports splits from WSplit (both 1.4.x and Nitrofski's 1.5.x fork), Time Split Tracker, SplitterZ,
LiveSplit and Urn. Llanfair is in the works.

## Uploading
We have drag-anywhere-on-any-page uploading, in a fashion similar to Imgur. The entire page lives in a `#dropzone` div
that listens for mouse drag events (for page dimming) and mouse drop events (for file handling).

If we receive a file drop, we construct an in-page POST request containing the file and send it off to the server behind
the scenes. The server parses the file and, if successful, responds with an ID for the new run's page, which we then
have JavaScript direct the browser to.

Alternatively, there is a manual upload form at `/upload`.


## Running locally

### Requirements
* Ruby 2.2.2
* PostgreSQL

### Configuration
Copy `config/application.example.yml` to `config/application.yml` and give it a once-over (especially if you want login
to work locally).

### First run
```bash
bundle install
rails server
```

*(Problems with the above? Open an issue! Still working out the kinks in the setup steps.)*

## API
See the full API documentation in the [API readme](./docs/api.md) file.

## Parsing
If you're interested in how we parse run files from different programs, check out the [parsing
readme](./docs/parsing.md) file.

[1]: https://github.com/laserlemon/figaro
