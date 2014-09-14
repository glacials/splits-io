
## splits i/o

splits i/o is a website similar to Pastebin or GitHub Gist, but for splits
generated from speedruns rather than text or code. It's written in Ruby on
Rails.

splits i/o currently supports splits from WSplit (both 1.4.x and Nitrofski's
1.5.x fork), Time Split Tracker, SplitterZ, and LiveSplit. Llanfair is in the
works.

### Uploading

We have drag-anywhere-on-any-page uploading, in a fashion similar to Imgur. The
entire page lives in a `#dropzone` div that listens for mouse drag events (for
page dimming) and mouse drop events (for file handling).

If we receive a file drop, we construct an in-page POST request containing the
file and send it off to the server behind the scenes. The server parses the
file and, if successful, responds with a random base 64 ID for the new run's
page, which we then have JavaScript direct the browser to.

Alternatively, there is a manual upload form at `/upload`.

### Parsing

Each file format reader is implemented as an [LL parser][2], which means that
we actually treat each format as its own context-free grammar. This means we
get to validate the data as we are reading it. It also means that it's pretty
simple to implement a new format (i.e. support a new splitting program). And as
icing on top, it becomes super easy to tell one splits format apart from
another when we need to parse.

#### Example

Let's say we have a rule that says something like

    TitleLine -> "Title=" Title Newline

which can be read as "a title line consists of the string `Title=` followed by
a title (which we will define later), followed by a newline. So later on, we
can complete our definition by doing

    Title -> /([^,\r\n]*)/

which is just a regular expression that says "a title consists of any number of
characters which aren't commas or newline characters". All we have to do now is
define our `Newline` rule:

    Newline -> "\r\n"
             | "\n"

This just means that a newline can be Windows-style newline (`\r\n`) or a
Unix-style newline (`\n`). The parser will match whichever one it sees.

So if we have a line like

    Title=Sonic Colors\n

the `TitleLine` will match successfully, as it can see all three required
elements. Let's try out some splits. We'll look at the Time Split Tracker
format now.

    Death Egg Robot	33.74
    /Users/glacials/split_images/sonic/death_egg_robot.png
    Perfect Chaos	1770.8
    /Users/glacials/split_images/sonic/perfect_chaos.png
    Egg Dragoon	2280.32
    /Users/glacials/split_images/sonic/egg_dragoon.png
    Time Eater	387.91
    /Users/glacials/split_images/sonic/time_eater.png

This is a bit more complicated. Each split has a title, a time, and a path to
an image on the user's local machine. Obviously we can't do anything about the
image path, but we should match against it anyway just to be thorough.

Additionally, in this format some elements are separated by tab characters
(e.g. the split title and time, if you didn't notice), while others are
separated by newlines.

Let's pretend we already have a rule somewhat like

    SplitLines -> Split SplitLines
                | Split

which reads "a `SplitLines` item should consist of a `Split` followed by
another `SplitLines` item, or of just a `Split`". This allows us to read in as
many splits as we can, because the rule will match against itself as many times
as it needs to.

So, let's match the splits themselves:

    Split -> Title Tab Time Newline ImagePath Newline

    Title     -> /([^\t]*)/
    Time      -> /(\d*\.\d*)/
    ImagePath -> /([^\r\n]*)/

    Tab     -> "\t"
    Newline -> "\n"
             | "\r\n"

By matching only against digit characters (`\d`) for our times, we immediately
fail the parse if we see anything we're not expecting, instead of checking (or
worse, forgetting to check) the values later down the line.

When we perform this parse on a split from Time Split Tracker, we should get an
object in return that we can call things like `split.title` and `split.time`
on.

#### In the code

To accomplish all this, we use the parser generator [Babel-Bridge][3], which is
available in a neat little gem. Check out the actual implementations of all
this stuff in the `lib/<name-of-splitting-program>_parser.rb` files.

### Running locally

#### First run

With Ruby and Bundler installed, you should be able to

```bash
git clone git://github.com/glacials/splits-io
cd splits-io
bundle install
rails server
```

#### Environment variables

We use [Figaro][4] to manage environment variables. This means that instead of setting them yourself, you can just go
copy `config/application.example.yml` to `config/application.yml` and fill them out there. You can also opt to set them
manually if you prefer to do that.

If you're using Heroku for production, use `figaro heroku:set -e production` to push all the appropriate environment
variables there.

##### Logging in

To get Twitch authentication working, you'll need to register a developer application at
http://www.twitch.tv/settings/connections. When you do, fill out the `TWITCH_CLIENT_ID` and `TWITCH_CLIENT_SECRET`
environment variables with the appropriate information.

##### Production database

Development mode (the default when using `rails server`) should work just fine at this point. To run in production mode,
you will need some additional environment variables set.

Production expects a PostgreSQL database server, so you'll want to set the following environment variables to use one:

    splitsio_db_host
    splitsio_db_port
    splitsio_db_name
    splitsio_db_username
    splitsio_db_password

You will also need to set a 30+ character secret key base, which is used to sign cookies:

    splitsio_secret_key_base

You can generate a secure key for this with `rake secret`.

[1]: https://github.com/skoh-fley/splits-io/blob/master/lib/wsplit_parser.rb
[2]: http://en.wikipedia.org/wiki/LL_parser
[3]: https://github.com/shanebdavis/Babel-Bridge
[4]: https://github.com/laserlemon/figaro
