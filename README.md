# splits i/o
splits i/o is a website similar to Pastebin or GitHub Gist, but for splits generated from speedruns rather than text or
code. It's written in Ruby on Rails.

splits i/o currently supports splits from WSplit (both 1.4.x and Nitrofski's 1.5.x fork), Time Split Tracker, SplitterZ,
and LiveSplit. Llanfair is in the works.

## Uploading
We have drag-anywhere-on-any-page uploading, in a fashion similar to Imgur. The entire page lives in a `#dropzone` div
that listens for mouse drag events (for page dimming) and mouse drop events (for file handling).

If we receive a file drop, we construct an in-page POST request containing the file and send it off to the server behind
the scenes. The server parses the file and, if successful, responds with an ID for the new run's page, which we then
have JavaScript direct the browser to.

Alternatively, there is a manual upload form at `/upload`.


## Running locally

### Requirements
* Ruby 2.1.5

### First run

```bash
bundle install
rails server
```

### Environment variables
We use [Figaro][1] to manage environment variables. This means that instead of setting them yourself, you can just go
copy `config/application.example.yml` to `config/application.yml` and fill them out there. You can also opt to set them
manually if you prefer to do that.

If you're using Heroku for production, use `figaro heroku:set -e production` to push all the appropriate environment
variables there.

#### Authentication
Accounts are powered 100% by Twitch authentication, so you'll need to register a developer application at
http://www.twitch.tv/settings/connections. When you do, fill out the `TWITCH_CLIENT_ID` and `TWITCH_CLIENT_SECRET`
environment variables with the appropriate values.

#### Production
To deploy splits-io to a production environment, set a Rails 4.1+ style `DATABASE_URL` environment variable. (This style
is replacing `database.yml` files.)

You'll also need to set a 30+ character secret key base and put it in the `splitsio_secret_key_base` environment
variable. This is used by Rails to sign cookies and you should keep it secret. You can generate a secure key for this
with `rake secret`.

## API
See the full API documentation in the [API readme](./docs/api.md) file.

## Parsing
If you're interested in how we parse run files from different programs, check out the [parsing
readme](./docs/parsing.md) file.

[1]: https://github.com/laserlemon/figaro
