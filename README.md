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

## Parsing

Each file format reader is implemented as an [LL parser][2], which means that we actually treat each format as its own
context-free grammar. This means we get to validate the data as we are reading it. It also means that it's pretty simple
to implement a new format (i.e. support a new splitting program). And as icing on top, it becomes super easy to tell one
splits format apart from another when we need to parse.

### Example

Let's say we have a rule that says something like

    TitleLine -> "Title=" Title Newline

which can be read as "a title line consists of the string `Title=` followed by a title (which we will define later),
followed by a newline. So later on, we can complete our definition by doing

    Title -> /([^,\r\n]*)/

which is just a regular expression that says "a title consists of any number of characters which aren't commas or
newline characters". All we have to do now is define our `Newline` rule:

    Newline -> "\r\n"
             | "\n"

This just means that a newline can be Windows-style newline (`\r\n`) or a Unix-style newline (`\n`). The parser will
match whichever one it sees.

So if we have a line like

    Title=Sonic Colors\n

the `TitleLine` will match successfully, as it can see all three required elements. Let's try out some splits. We'll
look at the Time Split Tracker format now.

    Death Egg Robot	33.74
    /Users/glacials/split_images/sonic/death_egg_robot.png
    Perfect Chaos	1770.8
    /Users/glacials/split_images/sonic/perfect_chaos.png
    Egg Dragoon	2280.32
    /Users/glacials/split_images/sonic/egg_dragoon.png
    Time Eater	387.91
    /Users/glacials/split_images/sonic/time_eater.png

This is a bit more complicated. Each split has a title, a time, and a path to an image on the user's local machine.
Obviously we can't do anything about the image path, but we should match against it anyway just to be thorough.

Additionally, in this format some elements are separated by tab characters (e.g. the split title and time, if you didn't
notice), while others are separated by newlines.

Let's pretend we already have a rule somewhat like

    SplitLines -> Split SplitLines
                | Split

which reads "a `SplitLines` item should consist of a `Split` followed by another `SplitLines` item, or of just a
`Split`". This allows us to read in as many splits as we can, because the rule will match against itself as many times
as it needs to.

So, let's match the splits themselves:

    Split -> Title Tab Time Newline ImagePath Newline

    Title     -> /([^\t]*)/
    Time      -> /(\d*\.\d*)/
    ImagePath -> /([^\r\n]*)/

    Tab     -> "\t"
    Newline -> "\n"
             | "\r\n"

By matching only against digit characters (`\d`) for our times, we immediately fail the parse if we see anything we're
not expecting, instead of checking (or worse, forgetting to check) the values later down the line.

When we perform this parse on a split from Time Split Tracker, we should get an object in return that we can call things
like `split.title` and `split.time` on.

### In the code

To accomplish all this, we use the parser generator [Babel-Bridge][3], which is available in a neat little gem. Check
out the actual implementations of all this stuff in the `lib/<name-of-splitting-program>_parser.rb` files.

## Running locally

### First run

With Ruby and Bundler installed, you should be able to

```bash
git clone git://github.com/glacials/splits-io
cd splits-io
bundle install
rails server
```

### Environment variables

We use [Figaro][4] to manage environment variables. This means that instead of setting them yourself, you can just go
copy `config/application.example.yml` to `config/application.yml` and fill them out there. You can also opt to set them
manually if you prefer to do that.

If you're using Heroku for production, use `figaro heroku:set -e production` to push all the appropriate environment
variables there.

#### Logging in

To get Twitch authentication working, you'll need to register a developer application at
http://www.twitch.tv/settings/connections. When you do, fill out the `TWITCH_CLIENT_ID` and `TWITCH_CLIENT_SECRET`
environment variables with the appropriate information.

#### Production database

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

## API

splits-io has an API consisting of lookup routes and retrieval routes at `/api/v1/:resource` and `/api/v1/:resource/:id`,
respectively. You can also POST to `/api/v1/runs`.

### Lookup routes
These routes will accept one or more URL parameters to allow you to look up resources by something that's not a unique
ID. However, they'll only return the ID of the thing you're looking for, so you'll have to use the classic retrieval
routes (documented below) to get any actual information.

#### GET [/api/v1/games][api-games-index]

##### Parameters accepted
`name`, `shortname`

##### Example request
```bash
curl splits.io/api/v1/games?shortname=tww
```
##### Example response
```json
[
  {
    "id": 4,
    "name": "The Legend of Zelda: The Wind Waker",
    "shortname": "tww",
    "created_at": "2014-04-18T06:28:54.258Z",
    "updated_at": "2014-09-23T09:51:57.195Z",
    "categories": [
      {
        "id": 4,
        "name": "Any% No Tuner",
        "game_id": 4,
        "created_at": "2014-04-18T06:28:54.295Z",
        "updated_at": "2014-04-18T06:28:54.295Z",
        "best_known_run": 2792
      },
      {
        "id": 37,
        "name": "Any% (English, No Tuner)",
        "game_id": 4,
        "created_at": "2014-04-18T06:29:26.810Z",
        "updated_at": "2014-04-18T06:29:26.810Z",
        "best_known_run": 1966
      },
      ...
      {
        "id": 426,
        "name": "100%",
        "game_id": 4,
        "created_at": "2014-08-13T13:07:15.339Z",
        "updated_at": "2014-08-13T13:07:15.339Z",
        "best_known_run": 2005
      }
    ]
  }
]
```

[api-games-index]: http://splits.io/api/v1/games

#### GET [/api/v1/categories][api-categories-index]

##### Parameters accepted
`game_id`

##### Example request
```bash
curl splits.io/api/v1/categories?game_id=4
```

##### Example response
```json
[
  {
    "id": 4,
    "name": "Any% No Tuner",
    "game_id": 4,
    "created_at": "2014-04-18T06:28:54.295Z",
    "updated_at": "2014-04-18T06:28:54.295Z",
    "best_known_run": 2792
  },
  {
    "id": 37,
    "name": "Any% (English, No Tuner)",
    "game_id": 4,
    "created_at": "2014-04-18T06:29:26.810Z",
    "updated_at": "2014-04-18T06:29:26.810Z",
    "best_known_run": 1966
  },
  ...
  {
    "id": 426,
    "name": "100%",
    "game_id": 4,
    "created_at": "2014-08-13T13:07:15.339Z",
    "updated_at": "2014-08-13T13:07:15.339Z",
    "best_known_run": 2005
  }
]
```

[api-categories-index]: http://splits.io/api/v1/categories

#### GET [/api/v1/runs][api-runs-index]

##### Parameters accepted
`category_id`, `user_id`

##### Example request
```bash
curl splits.io/api/v1/runs?user_id=1
```

##### Example response
```json
[
  {
    "id": 437,
    "url": "http://splits.io/c5",
    "name": "Transformers: Fall of Cybertron Any% (New Game+)",
    "time": 9053.47,
    "user_id": 1,
    "game_id": 31,
    "category_id": 40,
    "hits": 96,
    "program": "livesplit",
    "image_url": null,
    "created_at": "2014-03-09T19:07:38.809Z",
    "updated_at": "2014-10-28T04:18:41.436Z",
    "splits": [
      {
        "best": {
          "duration": 447.71
        },
        "name": "The Exodus",
        "finish_time": 447.71,
        "duration": 447.71
      },
      {
        "best": {
          "duration": 1193.8
        },
        "name": "Defend the Ark",
        "finish_time": 1651.53,
        "duration": 1203.82
      },
      ...
      {
        "best": {
          "duration": 483.810506
        },
        "name": "Till All Are One",
        "finish_time": 9053.47,
        "duration": 504.28999999999905
      }
    ]
  },
  {
    "id": 438,
    "url": "http://splits.io/c6",
    "name": "Sonic Colors",
    "time": 5083.74,
    "user_id": 1,
    "game_id": 1,
    "category_id": 1,
    "hits": 118,
    "program": "wsplit",
    "image_url": null,
    "created_at": "2014-03-09T19:07:46.483Z",
    "updated_at": "2014-10-23T06:50:06.870Z",
    "splits": [
      {
        "best": {
          "duration": 462.85
        },
        "name": "Rotatatron",
        "duration": 501.7,
        "finish_time": 501.7
      },
      {
        "best": {
          "duration": 719.44
        },
        "name": "Captain Jelly",
        "duration": 754.9099999999999,
        "finish_time": 1256.61
      },
      ...
      {
        "best": {
          "duration": 44.7199999999993
        },
        "name": "Epilogue",
        "duration": 44.719999999999345,
        "finish_time": 5083.74
      }
    ]
  },
  ...
  {
    "id": 1686,
    "url": "http://splits.io/1au",
    "name": "Super Mario Sunshine Any%",
    "time": 5772.156,
    "user_id": 1,
    "game_id": 15,
    "category_id": 21,
    "hits": 119,
    "program": "livesplit",
    "image_url": null,
    "created_at": "2014-07-19T17:35:06.327Z",
    "updated_at": "2014-10-28T04:41:12.368Z",
    "splits": [
      {
        "best": {
          "duration": 206.634404
        },
        "name": "Airstrip",
        "finish_time": 208.676429,
        "duration": 208.676429
      },
      {
        "best": {
          "duration": 453.647702
        },
        "name": "Bianco 2",
        "finish_time": 694.017941,
        "duration": 485.34151199999997
      },
      ...
      {
        "best": {
          "duration": 210.046238
        },
        "name": "Bowser",
        "finish_time": 5772.156,
        "duration": 1136.1422860000002
      }
    ]
  }
]
```

[api-runs-index]: http://splits.io/api/v1/runs

#### GET [/api/v1/users][api-users-index]

##### Parameters accepted
`name`, `twitch_id`

##### Example request
```bash
curl splits.io/api/v1/users?name=glacials
```

##### Example response
```json
[
  {
    "id": 1,
    "twitch_id": 29798286,
    "name": "glacials",
    "created_at": "2014-03-09T19:00:43.640Z",
    "updated_at": "2014-10-28T03:48:31.187Z"
  }
]
```

[api-users-index]: http://splits.io/api/v1/users

### Retrieval routes
These are the routes that will actually give you information about individual resources. They only accept numeric ids,
which can be discovered through the above index routes.

#### GET [/api/v1/games/:id][api-games-show]

##### Example request
```bash
curl splits.io/api/v1/games/4
```

##### Example response
```json
{
  "id": 4,
  "name": "The Legend of Zelda: The Wind Waker",
  "shortname": "tww",
  "created_at": "2014-04-18T06:28:54.258Z",
  "updated_at": "2014-09-23T09:51:57.195Z",
  "categories": [
    {
      "id": 4,
      "name": "Any% No Tuner",
      "game_id": 4,
      "created_at": "2014-04-18T06:28:54.295Z",
      "updated_at": "2014-04-18T06:28:54.295Z",
      "best_known_run": 2792
    },
    {
      "id": 37,
      "name": "Any% (English, No Tuner)",
      "game_id": 4,
      "created_at": "2014-04-18T06:29:26.810Z",
      "updated_at": "2014-04-18T06:29:26.810Z",
      "best_known_run": 1966
    },
    ...
    {
      "id": 426,
      "name": "100%",
      "game_id": 4,
      "created_at": "2014-08-13T13:07:15.339Z",
      "updated_at": "2014-08-13T13:07:15.339Z",
      "best_known_run": 2005
    }
  ]
}
```

[api-games-show]: http://splits.io/api/v1/games/4

#### GET [/api/v1/categories/:id][api-categories-show]

##### Example request
```bash
curl splits.io/api/v1/categories/4
```

##### Example response
```json
{
  "id": 4,
  "name": "Any% No Tuner",
  "game_id": 4,
  "created_at": "2014-04-18T06:28:54.295Z",
  "updated_at": "2014-04-18T06:28:54.295Z",
  "best_known_run": 2792
}
```

[api-categories-show]: http://splits.io/api/v1/categories/1

#### GET [/api/v1/runs/:id][api-runs-show]

##### Example request
```bash
curl splits.io/api/v1/runs/1952
```

##### Example response
```json
{
  "id": 1952,
  "url": "http://splits.io/1i8",
  "name": "The Legend of Zelda: The Wind Waker Any% No Tuner",
  "time": 18445.61,
  "user_id": null,
  "game_id": 4,
  "category_id": 4,
  "hits": 21,
  "program": "livesplit",
  "image_url": "http://i.imgur.com/8fLqgSl.png",
  "created_at": "2014-08-11T07:36:54.922Z",
  "updated_at": "2014-10-28T08:08:11.285Z",
  "splits": [
    {
      "best": {
        "duration": 1163.24
      },
      "name": "Spoils Bag",
      "finish_time": 1163.24,
      "duration": 1163.24
    },
    {
      "best": {
        "duration": 388.39
      },
      "name": "Forsaken Fortress 1",
      "finish_time": 1560.32,
      "duration": 397.0799999999999
    },
    ...
    {
      "best": {
        "duration": 417.93
      },
      "name": "Ganon",
      "finish_time": 18445.61,
      "duration": 417.9300000000003
    }
  ]
}
```

[api-runs-show]: http://splits.io/api/v1/runs/1952

#### GET [/api/v1/users/:id][api-users-show]

##### Example request
```bash
curl splits.io/api/v1/users/1
```

##### Example response
```json
{
  "id": 1,
  "twitch_id": 29798286,
  "name": "glacials",
  "created_at": "2014-05-03T07:18:54.033Z",
  "updated_at": "2014-10-28T03:45:53.968Z"
}
```

[api-users-show]: http://splits.io/api/v1/users/1

### Uploading runs

#### POST [/api/v1/runs][api-runs-create]


##### Example request
```bash
curl -iX POST --form file=@/path/to/splits_file.lss splits.io/api/v1/runs
```

##### Example response
When successful this endpoint doesn't return a body, just headers. You should get a 201 back and the `Location` field of
the headers should hold the location of the new run according to this API (`splits.io/api/v1/:id`).

If you want the user-accessible URL (`splits.io/:alphanumeric_id`) without having to perform another request, you can
just convert the numeric id into base 36 to get the alphanumeric id.

```
HTTP/1.1 201 Created
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Location: http://splits.io/4s
Content-Type: text/html
ETag: "7215ee9c7d9dc229d2921a40e899ec5f"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: bf53156c-6e71-48b8-9cb0-501878a7f0f5
X-Runtime: 1.054199
Connection: close
Server: thin
```

[api-runs-create]: http://splits.io/api/v1/runs

[1]: https://github.com/skoh-fley/splits-io/blob/master/lib/wsplit_parser.rb
[2]: http://en.wikipedia.org/wiki/LL_parser
[3]: https://github.com/shanebdavis/Babel-Bridge
[4]: https://github.com/laserlemon/figaro
