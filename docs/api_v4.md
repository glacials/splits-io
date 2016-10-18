# API v4

*Note: v4 is still under development. This doc is here to provide an idea of what it will look like, but many of these
routes are not implemented or not yet up to spec. For now you should use the [v3 API][v3].*

[v3]: https://github.com/glacials/splits-io/blob/master/docs/api.md

## IDs
Resources are identifyable *only* by the following attributes:

| Resource type | Key attribute | Description of key attribute | Examples of key attribute             |
|:--------------|:--------------|:-----------------------------|:--------------------------------------|
| Run           | ID            | A base 36 number             | 1b, 3nm, 1vr                          |
| Runner        | Name          | A Twitch username            | glacials, batedurgonnadie, snarfybobo |
| Game          | Shortname     | An SRL abbreviation          | sms, sm64, portal                     |
| Category      | ID            | A base 10 number             | 312, 1456, 11                         |

Your code shouldn't care too much about what these attributes actually are, as they're all represented as unique
strings. But of course as a human it's nice to be able to glean some meaning out of them.

## Run
```bash
curl https://splits.io/api/v4/runs/3nm
curl https://splits.io/api/v4/runs/3nm?historic=1
```
A Run maps 1:1 to an uploaded splits file.

| Field        | Type                                         | Can it be null?                                       | Description                                                                                                                                                                                                                                   |
|-------------:|:---------------------------------------------|:------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`         | string                                       | never                                                 | Unique ID for identifying the run on Splits I/O. This can be used to construct a user-facing URL or an API-facing one.                                                                                                                        |
| `srdc_id`    | string                                       | when no associated speedrun.com run                   | Unique ID for identifying the run on speedrun.com. This is typically supplied by the runner manually.                                                                                                                                         |
| `time`       | number                                       | never                                                 | Duration in seconds of the run.                                                                                                                                                                                                               |
| `program`    | string                                       | never                                                 | The name of the timer with which the run was recorded. This is typically an all lowercase, no-spaces version of the program name.                                                                                                             |
| `attempts`   | number                                       | when not supported by the source timer                | The number of run attempts recorded by the timer that generated the run's source file.                                                                                                                                                        |
| `image_url`  | string                                       | when not supplied by runner                           | A screenshot of the timer after a finished run. This is typically supplied automatically by timers which support auto-uploading runs to Splits I/O.                                                                                           |
| `created_at` | string                                       | never                                                 | The time and date at which this run's source file was uploaded to Splits I/O. This field conforms to [ISO 8601][iso8601].                                                                                                                     |
| `updated_at` | string                                       | never                                                 | The time and date at which this run was most recently modified on Splits I/O (modify events include disowning, adding a video or speedrun.com association, and changing the run's game/category). This field conforms to [ISO 8601][iso8601]. |
| `video_url`  | string                                       | when not supplied by runner                           | A URL for a Twitch, YouTube, or Hitbox video which can be used as proof of the run. This is supplied by the runner.                                                                                                                           |
| `game`       | Game object (see Game section)               | when unable to be determined / not supplied by runner | The game which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                           |
| `category`   | Category object (see Category section)       | when unable to be determined / not supplied by runner | The category which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                       |
| `runners`    | array of Runner objects (see Runner section) | when anonymously uploaded or disowned by runner       | The runner(s) who performed the run, if they claim credit.                                                                                                                                                                                    |

If a `historic=1` param is included in the request, one additional field will be present:

| Field        | Type                                         | Null when...                                          | Description                                                                                                                                                                                                                                   |
|-------------:|:---------------------------------------------|:------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `history`    | array of numbers                             | never                                                 | Ordered durations of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history.           |

### Splits
```bash
curl https://splits.io/api/v4/runs/3nm/splits
```
Runs usually contain Splits. Splits are a special type of resource in that they are not individually identifiable; they
do not have unique IDs. They are accessible only as an array of splits belonging to a Run.

*Terminology note: Although sometimes used synonymously (even here), a "segment" refers to the stretch of time a section
of game takes, where a "split" refers to the moment in time when it completes.*

| Field         | Type             | Can it be null?                   | Description                                                                                                                                                                                                                                            |
|--------------:|:-----------------|:----------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`        | string           | never                             | Name of the segment. This value is an exact copy of timers' fields.                                                                                                                                                                                    |
| `duration`    | number           | never                             | Duration in seconds of the segment.                                                                                                                                                                                                                    |
| `finish_time` | number           | never                             | The total elapsed time of the run at the moment when this segment was finished (such that the run's duration is equal to the final split's finish time). Provided in seconds.                                                                          |
| `best`        | number           | when not known                    | The shortest duration the runner has ever gotten on this segment.                                                                                                                                                                                      |
| `gold`        | boolean          | never                             | Whether or not this split *was* the shortest duration the runner has ever gotten on this segment. This field is shorthand for `duration == best`.                                                                                                      |
| `skipped`     | boolean          | never                             | Whether or not this split was skipped -- some timers let the runner skip over a split in case they forgot to hit their split button on time. Beware that a skipped split's duration is considered `0`, and instead is rolled into the following split. |
| `reduced`     | boolean          | never                             | Whether or not this segment was "reduced"; that is, had its duration affected by previous splits being skipped.                                                                                                                                        |

If a `historic=1` param is included in the request, one additional field will be present:

| Field         | Type             | Null when...                      | Description                                                                                                                                                                                                                                            |
|-------------:|:------------------|:----------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `history`     | array of numbers | never                             | Ordered durations of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history.                    |

When retrieving splits, you can pass the `historic=1` flag in order to include history in the resulting splits. **Please
include history only if you're using it.** Parsing history is computationally expensive, and your request may take an
order of magnitude longer to process, depending on the number of history entries the run has. For particularly hefty
runs, it is very possible that the request will simply time out. We're attempting to solve this for the future with
better caching and more optimized parsing, but for now it remains an extremely slow operation.

## Runner
```bash
curl https://splits.io/api/v4/runners/glacials
curl https://splits.io/api/v4/runners/glacials/runs
curl https://splits.io/api/v4/runners/glacials/pbs
curl https://splits.io/api/v4/runners/glacials/games
curl https://splits.io/api/v4/runners/glacials/categories
```
A Runner is a user who has at least one run tied to their account. Users with zero runs are not discoverable using the
API.

| Field        | Type   | Can it be null? | Description                                                                                                                |
|-------------:|:-------|:----------------|:---------------------------------------------------------------------------------------------------------------------------|
| `twitch_id`  | string | never           | The numeric Twitch ID of the user.                                                                                         |
| `name`       | string | never           | The Twitch name of the user.                                                                                               |
| `avatar`     | string | never           | The Twitch avatar of the user.                                                                                             |
| `created_at` | string | never           | The time and date at which this user first authenticated with Splits I/O. This field conforms to [ISO 8601][iso8601].      |
| `updated_at` | string | never           | The time and date at which this user was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601]. |

## Game
```bash
curl https://splits.io/api/v4/games
curl https://splits.io/api/v4/games/sms
curl https://splits.io/api/v4/games/sms/categories
curl https://splits.io/api/v4/games/sms/runners
```
Most timers allow users to specify a "game" field. A Game is a collection of information about the video game specified
in this field. Games have at least one run and have an associated shortname, usually scraped from SRD or SRDC, but
sometimes specified manually. If a game does not have an associated shortname, it is not a Game.

| Field        | Type                                             | Can it be null? | Description                                                                                                                          |
|-------------:|:-------------------------------------------------|:----------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| `name`       | string                                           | never           | The full title of the game, like "Super Mario Sunshine".                                                                             |
| `shortname`  | string                                           | when not known  | A shortened title of the game, like "sms". Where possible, this name tries to match with those on SpeedRunsLive and/or Speedrun.com. |
| `created_at` | string                                           | never           | The time and date at which this game was created on Splits I/O. This field conforms to [ISO 8601][iso8601].                          |
| `updated_at` | string                                           | never           | The time and date at which this game was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601].           |
| `categories` | array of Category objects (see Category section) | never           | The known speedrun categories for this game.                                                                                         |

## Category
```bash
curl https://splits.io/api/v4/categories/123
curl https://splits.io/api/v4/categories/123/runners
curl https://splits.io/api/v4/categories/123/runs
```
Some timers allow users to specify a "category" or similar field (any%, 100%, MST, etc.). A Category is a collection of
information about the type of run performed, more specific than a Game. Each Category belongs to a Game. Any number of
Categories can be associated with a Game.

| Field        | Type   | Can it be null? | Description                                                                                                                    |
|-------------:|:-------|:----------------|:-------------------------------------------------------------------------------------------------------------------------------|
| `id`         | string | never           | The numeric ID of the category.                                                                                                |
| `name`       | string | never           | The name of the category.                                                                                                      |
| `created_at` | string | never           | The time and date at which this category was created on Splits I/O. This field conforms to [ISO 8601][iso8601].                |
| `updated_at` | string | never           | The time and date at which this category was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601]. |

## Uploading
```bash
curl -X POST https://splits.io/api/v4/runs # then...
curl -X POST https://s3.amazonaws.com/splits.io --form file=@/path/to/file # some fields not shown; see below
```
Uploading runs is a two-step process. Our long-term storage for runs is on [S3][s3], so in the first request you'll tell
Splits I/O that you're about to upload a run, then in the second you'll upload it directly to S3 using some parameters
returned from the first. The two-request system is faster for you (we don't have to receive your whole run then make you
wait for us to put it on S3) and more resilient for us (we don't have to spend a bunch of CPU time waiting on uploads).

The first request will return a body like
```json
{
  "status": 201,
  "message": "Run reserved. Use the included presigned request to upload the file to S3, with an additional `file` field containing the run file.",
  "id": "rez",
  "claim_token": "pBeUPBM9IaWqbaF11ocUksXS",
  "uris": {
    "api_uri": "https://splits.io/api/v4/runs/rez",
    "public_uri": "https://splits.io/rez",
    "claim_uri": "https://splits.io/rez?claim_token=pBeUPBM9IaWqbaF11ocUksXS"
  },
  "presigned_request": {
    "method": "POST",
    "uri": "https://s3.amazonaws.com/splits.io",
    "fields": {
      "key": "splits/rez",
      "policy": "gibberish",
      "x-amz-credential": "other gibberish",
      "x-amz-algorithm": "more gibberish",
      "x-amz-date": "even more gibberish",
      "x-amz-signature": "most gibberish",
    }
  }
}
```
The above example would have your second request look like
```bash
curl -X POST https://s3.amazonaws.com/splits.io \
  --form key="splits/rez" \
  --form policy="gibberish" \
  --form x-amz-credential="other gibberish" \
  --form x-amz-algorithm="more gibberish" \
  --form x-amz-date="even more gibberish" \
  --form x-amz-signature="most gibberish" \
  --form file=@/path/to/file
```
This is called a presigned request. Each field above -- except `file`, that's yours -- is directly copied from the
response of the first request. You don't need to inspect or care about the contents of the fields, as long as you
include them. They serve as authorization for you to upload a file to S3 with Splits I/O's permission.

Each presigned request can only be successfully made once, and expires if not made within an hour.

[s3]: https://aws.amazon.com/s3

### Giving the run an owner
If your intention is for this run to belong to a user, you'll need to send that user to the `uris.claim_uri` URI
returned from the first request. If they're logged in when they visit this URI, their account will automatically claim
the run.

## Converting
```bash
curl -X POST https://splits.io/api/v4/convert?program=livesplit --form file=@/path/to/file
```
When converting between timer formats, the file and program parameters must be included. If you are converting a
LiveSplit file and would like to include the history, then the `historic=1` parameter can also be included.  The JSON
format is outputted as described above in the form of a .json file.

## FAQ

### Why are IDs strings?
IDs are opaque. To you, the consumer, it doesn't matter what the actual number itself is because the only purpose it
serves is be given back to Splits I/O later. You don't need to look inside it, you don't need to perform arithmetic on
it, you don't need it rounded or floored or rid of leading zeroes. You don't need to do any numbery things to them. And
in fact if you do do numbery things to them, even accidentally, there's a good chance you've broken them in the process.

It doesn't matter that on Splits I/O's end they happen to be auto-incrementing base 10 numbers, because none of that
matters to you. By giving you a number type, we'd be implying that it did. Strings are opaque. Strings are what you'd
end up casting your IDs to anyway in order to hit the API with them again. So let's just take the negligible hit and
save you a step.

[iso8601]: https://en.wikipedia.org/wiki/ISO_8601
