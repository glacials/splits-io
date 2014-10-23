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
respectively. Here's how to get information.

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
[4]
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
[4,37,127,372,394,406,405,426]
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
[437,438,1329,1127,1957,1193,1262,1686]
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
[1]
```

[api-users-index]: http://splits.io/api/v1/users

### Retrieval routes
These are the routes that will actually give you information about resources. These routes will only accept numeric ids
for resources.

#### GET [/api/v1/games/:id][api-games-show]

##### Example request

```bash
curl splits.io/api/v1/games/4
```

##### Example response

    {
      "id": 4,
      "name": "The Legend of Zelda: The Wind Waker",
      "created_at": "2014-04-18T06:28:54.258Z",
      "updated_at": "2014-09-23T09:51:57.195Z",
      "shortname": "tww",
      "categories": [
        {
          "id": 4,
          "name": "Any% No Tuner",
          "created_at": "2014-04-18T06:28:54.295Z",
          "updated_at": "2014-04-18T06:28:54.295Z"
        },
        {
          "id": 37,
          "name": "Any% (English, No Tuner)",
          "created_at": "2014-04-18T06:29:26.810Z",
          "updated_at": "2014-04-18T06:29:26.810Z"
        },
        {
          "id": 127,
          "name": "Any% Glitchless",
          "created_at": "2014-05-23T00:05:27.677Z",
          "updated_at": "2014-05-23T00:05:27.677Z"
        },
        {
          "id": 372,
          "name": "Any%",
          "created_at": "2014-07-31T03:16:28.389Z",
          "updated_at": "2014-07-31T03:16:28.389Z"
        },
        {
          "id": 394,
          "name": "Any% (Japanese, No Tuner)",
          "created_at": "2014-08-10T04:27:13.319Z",
          "updated_at": "2014-08-10T04:27:13.319Z"
        },
        {
          "id": 406,
          "name": "Master Sword (Eng, no Tuner)",
          "created_at": "2014-08-10T05:49:32.751Z",
          "updated_at": "2014-08-10T05:49:32.751Z"
        },
        {
          "id": 405,
          "name": "Din's Pearl",
          "created_at": "2014-08-10T05:49:25.140Z",
          "updated_at": "2014-08-10T05:49:25.140Z"
        },
        {
          "id": 426,
          "name": "100%",
          "created_at": "2014-08-13T13:07:15.339Z",
          "updated_at": "2014-08-13T13:07:15.339Z"
        }
      ]
    }

[api-games-show]: http://splits.io/api/v1/games/4

#### GET [/api/v1/categories/:id][api-categories-show]

##### Example request

```bash
curl splits.io/api/v1/categories/4
```

##### Example response

    {
      "id": 4,
      "name": "Any% No Tuner",
      "created_at": "2014-04-18T06:28:54.295Z",
      "updated_at": "2014-04-18T06:28:54.295Z"
    }

#### GET [/api/v1/runs/:id][api-runs-show]

##### Example request

```bash
curl splits.io/api/v1/runs/1952
```

##### Example response

    {
      "id": 1952,
      "created_at": "2014-08-11T07:36:54.922Z",
      "updated_at": "2014-10-06T06:13:13.448Z",
      "nick": "TbqK",
      "hits": 18,
      "image_url": "http://i.imgur.com/8fLqgSl.png",
      "name": "The Legend of Zelda: The Wind Waker Any% No Tuner",
      "time": "18445.61",
      "program": "livesplit",
      "game": {
        "id": 4,
        "name": "The Legend of Zelda: The Wind Waker",
        "created_at": "2014-04-18T06:28:54.258Z",
        "updated_at": "2014-09-23T09:51:57.195Z",
        "shortname": "tww"
      },
      "category": {
        "id": 4,
        "name": "Any% No Tuner",
        "created_at": "2014-04-18T06:28:54.295Z",
        "updated_at": "2014-04-18T06:28:54.295Z"
      },
      "user": null,
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
        {
          "best": {
            "duration": 582.888967
          },
          "name": "Delivery Bag",
          "finish_time": 2151.65,
          "duration": 591.3300000000002
        },
        {
          "best": {
            "duration": 689.18
          },
          "name": "Grappling Hook",
          "finish_time": 2840.83,
          "duration": 689.1799999999998
        },
        {
          "best": {
            "duration": 243.4
          },
          "name": "Dragon Roost Cavern",
          "finish_time": 3101.64,
          "duration": 260.80999999999995
        },
        {
          "best": {
            "duration": 583.99
          },
          "name": "Deku Leaf",
          "finish_time": 3725.71,
          "duration": 624.0700000000002
        },
        {
          "best": {
            "duration": 328.51
          },
          "name": "Boomerang",
          "finish_time": 4073.15,
          "duration": 347.44000000000005
        },
        {
          "best": {
            "duration": 222.738616
          },
          "name": "Forbidden Woods",
          "finish_time": 4336.99,
          "duration": 263.8399999999997
        },
        {
          "best": {
            "duration": 844.88
          },
          "name": "Bombs",
          "finish_time": 5218.28,
          "duration": 881.29
        },
        {
          "best": {
            "duration": 494.15
          },
          "name": "Nayru's Pearl",
          "finish_time": 5735.82,
          "duration": 517.54
        },
        {
          "best": {
            "duration": 611.25
          },
          "name": "Hero's Bow",
          "finish_time": 6347.07,
          "duration": 611.25
        },
        {
          "best": {
            "duration": 486.94
          },
          "name": "Tower of the Gods",
          "finish_time": 6834.01,
          "duration": 486.9400000000005
        },
        {
          "best": {
            "duration": 276.37
          },
          "name": "Master Sword",
          "finish_time": 7110.89,
          "duration": 276.8800000000001
        },
        {
          "best": {
            "duration": 627.34
          },
          "name": "Skull Hammer",
          "finish_time": 7873.25,
          "duration": 762.3599999999997
        },
        {
          "best": {
            "duration": 251.302345
          },
          "name": "Forsaken Fortress 2",
          "finish_time": 8130.18,
          "duration": 256.9300000000003
        },
        {
          "best": {
            "duration": 892.47
          },
          "name": "Power Bracelets",
          "finish_time": 9022.65,
          "duration": 892.4699999999993
        },
        {
          "best": {
            "duration": 919.27
          },
          "name": "Iron Boots",
          "finish_time": 10084.06,
          "duration": 1061.4099999999999
        },
        {
          "best": {
            "duration": 600.85
          },
          "name": "Mirror Shield",
          "finish_time": 10684.91,
          "duration": 600.8500000000004
        },
        {
          "best": {
            "duration": 472.75
          },
          "name": "Earth Temple",
          "finish_time": 11234.53,
          "duration": 549.6200000000008
        },
        {
          "best": {
            "duration": 715.29
          },
          "name": "Hookshot",
          "finish_time": 11949.82,
          "duration": 715.289999999999
        },
        {
          "best": {
            "duration": 425.65
          },
          "name": "Wind Temple",
          "finish_time": 12694.68,
          "duration": 744.8600000000006
        },
        {
          "best": {
            "duration": 502.51
          },
          "name": "Overlook Chart",
          "finish_time": 13222.45,
          "duration": 527.7700000000004
        },
        {
          "best": {
            "duration": 252.36
          },
          "name": "Cabana Chart",
          "finish_time": 13545.47,
          "duration": 323.0199999999986
        },
        {
          "best": {
            "duration": 271.88
          },
          "name": "Stonewatcher Chart",
          "finish_time": 13826.11,
          "duration": 280.64000000000124
        },
        {
          "best": {
            "duration": 386.43
          },
          "name": "Ghost Ship Chart",
          "finish_time": 14212.54,
          "duration": 386.4300000000003
        },
        {
          "best": {
            "duration": 824.89
          },
          "name": "Savage Labyrinth",
          "finish_time": 15075,
          "duration": 862.4599999999991
        },
        {
          "best": {
            "duration": 459.16
          },
          "name": "3184 Rupees",
          "finish_time": 15545.37,
          "duration": 470.3700000000008
        },
        {
          "best": {
            "duration": 677.02
          },
          "name": "Deciphered Charts",
          "finish_time": 16225.65,
          "duration": 680.2799999999988
        },
        {
          "best": {
            "duration": 805.23
          },
          "name": "Completed Triforce",
          "finish_time": 17030.88,
          "duration": 805.2300000000014
        },
        {
          "best": {
            "duration": 488.83
          },
          "name": "Light Arrows",
          "finish_time": 17535.77,
          "duration": 504.8899999999994
        },
        {
          "best": {
            "duration": 414.75
          },
          "name": "Puppet Ganon",
          "finish_time": 18027.68,
          "duration": 491.90999999999985
        },
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

#### GET [/api/v1/users/:id][api-users-show]

##### Example request

```bash
curl splits.io/api/v1/users/1
```

##### Example response

    {
      "id": 1,
      "created_at": "2014-03-09T19:00:43.640Z",
      "updated_at": "2014-10-23T06:44:08.106Z",
      "twitch_id": 29798286,
      "name": "glacials"
    }

[api-categories-show]: http://splits.io/api/v1/categories/1
[api-runs-show]: http://splits.io/api/v1/runs/1
[api-users-show]: http://splits.io/api/v1/users/1

[1]: https://github.com/skoh-fley/splits-io/blob/master/lib/wsplit_parser.rb
[2]: http://en.wikipedia.org/wiki/LL_parser
[3]: https://github.com/shanebdavis/Babel-Bridge
[4]: https://github.com/laserlemon/figaro
