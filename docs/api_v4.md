# API v4

## IDs
Resources are identifyable *only* by the following attributes:

| Resource type | Key attribute | Description of key attribute | Examples of key attribute             |
|:--------------|:--------------|:-----------------------------|:--------------------------------------|
| Run           | ID            | A base 36 number             | 1b, 3nm, 1vr                          |
| Runner        | Name          | A Twitch username            | glacials, batedurgonnadie, snarfybobo |
| Game          | Shortname     | An SRL abbreviation          | sms, sm64, portal                     |
| Category      | ID            | A base 10 number             | 312, 1456, 11                         |

Your code shouldn't care too much about what these attributes actually are, as they're all represented as unique
strings. But as a human it's nice to be able to glean some meaning out of them.

## Run
```bash
curl https://splits.io/api/v4/runs/3nm
curl https://splits.io/api/v4/runs/3nm?historic=1
```
A Run maps 1:1 to an uploaded splits file.

| Field        | Type                                         | Null when...                                     | Description                                                                                                                                                                                                                                  |
|-------------:|:---------------------------------------------|:-------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`         | string                                       | never                                            | Unique ID for identifying the run on Splits I/O. This can be used to construct a user-facing URL or an API-facing one.                                                                                                                        |
| `srdc_id`    | string                                       | no associated speedrun.com run                   | Unique ID for identifying the run on speedrun.com. This is typically supplied by the runner manually.                                                                                                                                        |
| `name`       | string                                       | never                                            | Name of the run. For timers that support a "name" or similar field, this value is an exact copy of that field. For other timers, this is typically "%full_game_name% %full_category_name%".                                                  |
| `time`       | number                                       | never                                            | Duration in seconds of the run.                                                                                                                                                                                                              |
| `program`    | string                                       | never                                            | The name of the timer with which the run was recorded. This is typically an all lowercase, no-spaces version of the program name.                                                                                                            |
| `attempts`   | number                                       | not supported by the source timer                | The number of run attempts recorded by the timer that generated the run's source file.                                                                                                                                                       |
| `image_url`  | string                                       | not supplied by runner                           | A screenshot of the timer after a finished run. This is typically supplied automatically by timers which support auto-uploading runs to Splits I/O.                                                                                           |
| `created_at` | string                                       | never                                            | The time and date at which this run's source file was uploaded to Splits I/O. This field conforms to [ISO 8601][iso8601].                                                                                                                     |
| `updated_at` | string                                       | never                                            | The time and date at which this run was most recently modified on Splits I/O (modify events include disowning, adding a video or speedrun.com association, and changing the run's game/category). This field conforms to [ISO 8601][iso8601]. |
| `video_url`  | string                                       | not supplied by runner                           | A URL for a Twitch, YouTube, or Hitbox video which can be used as proof of the run. This is supplied by the runner.                                                                                                                          |
| `game`       | Game object (see Game section)               | unable to be determined / not supplied by runner | The game which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                          |
| `category`   | Category object (see Category section)       | unable to be determined / not supplied by runner | The category which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                      |
| `runners`    | array of Runner objects (see Runner section) | anonymously uploaded or disowned by runner       | The runner(s) who performed the run, if they claim credit.                                                                                                                                                                                   |

If a `historic=1` param is included in the request, one additional field will be present:

| Field        | Type             | Null when... | Description                                                                                                                                                                                                                         |
|-------------:|:-----------------|:-------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `history`    | array of numbers | never        | Ordered durations of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history. |

[iso8601]: https://en.wikipedia.org/wiki/ISO_8601

### Splits
```bash
curl https://splits.io/api/v4/runs/3nm/splits
```
Runs usually contain Splits. Splits are a special type of resource in that they are not individually identifiable; they
do not have unique IDs. They are accessible only as an array of splits belonging to a Run.

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

## Game
```bash
curl https://splits.io/api/v4/games
curl https://splits.io/api/v4/games/sms
curl https://splits.io/api/v4/games/sms/categories
curl https://splits.io/api/v4/games/sms/runners
```
Most timers allow users to specify a "game" field. A Game is a collection of information about the video game specified
in this field. Games have at least one run and have an associated game on SRL. If a game does not have an associated
game on SRL, it is not a Game.

## Category
```bash
curl https://splits.io/api/v4/categories/123
curl https://splits.io/api/v4/categories/123/runners
curl https://splits.io/api/v4/categories/123/runs
```
Some timers allow users to specify a "category" or similar field. A Category is a collection of information about the
type of run performed, more specific than a Game. Each Category belongs to a Game. The definition of a category does not
hold any ties to SRL. Any number of Categories can be associated with a Game.

## Convert
```bash
curl -X POST https://splits.io/api/v4/convert?program=livesplit --form file=@/path/to/file
```
When converting between timer formats, the file and program parameters must be included. If you are converting a
LiveSplit file and would like to include the history, then the `historic=1` parameter can also be included.  The JSON
format is outputted as described above in the form of a .json file.
