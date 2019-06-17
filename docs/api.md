# API v4
The Splits I/O API supports retrieving runs, runners, games, and categories, as well as uploading, disowning, and deleting
runs. If you only want to upload runs, skip to [Uploading][uploading].

## IDs
Resources are identifyable *only* by the following attributes:

| Resource type        | Key attribute | Description of key attribute | Examples of key attribute             |
|:---------------------|:--------------|:-----------------------------|:--------------------------------------|
| [Run][run]           | ID            | A base 36 number             | 1b, 3nm, 1vr                          |
| [Runner][runner]     | Name          | A Twitch username            | glacials, batedurgonnadie, snarfybobo |
| [Game][game]         | Shortname     | An SRL abbreviation          | sms, sm64, portal                     |
| [Category][category] | ID            | A base 10 number             | 312, 1456, 11                         |
| [Race][racing]       | ID            | A UUID string                | asdf                                  |

Your code shouldn't care too much about what these attributes actually are, as they're all represented as unique
strings. But of course as a human it's nice to be able to glean some meaning out of them.

## Run
<details open>
<summary>Click to expand</summary>

```sh
curl https://splits.io/api/v4/runs/10x
curl https://splits.io/api/v4/runs/10x?historic=1
```
A Run maps 1:1 to an uploaded splits file.

| Field                     | Type                         | Can it be null?                                       | Description                                                                                                                                                                                                                                   |
|:--------------------------|:-----------------------------|:------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`                      | string                       | never                                                 | Unique ID for identifying the run on Splits I/O. This can be used to construct a user-facing URL or an API-facing one.                                                                                                                        |
| `srdc_id`                 | string                       | when no associated speedrun.com run                   | Unique ID for identifying the run on speedrun.com. This is typically supplied by the runner manually.                                                                                                                                         |
| `realtime_duration_ms`    | number                       | never                                                 | Realtime duration in milliseconds of the run.                                                                                                                                                                                                 |
| `realtime_sum_of_best_ms` | number                       | never                                                 | Realtime sum of best in milliseconds of the run.                                                                                                                                                                                              |
| `gametime_duration_ms`    | number                       | never                                                 | Gametime duration in milliseconds of the run.                                                                                                                                                                                                 |
| `gametime_sum_of_best_ms` | number                       | never                                                 | Gametime sum of best in milliseconds of the run.                                                                                                                                                                                              |
| `default_timing`          | string                       | never                                                 | The timing used for the run.  Will be either `real` or `game`.                                                                                                                                                                                |
| `program`                 | string                       | never                                                 | The name of the timer with which the run was recorded. This is typically an all lowercase, no-spaces version of the program name.                                                                                                             |
| `attempts`                | number                       | when not supported by the source timer                | The number of run attempts recorded by the timer that generated the run's source file.                                                                                                                                                        |
| `image_url`               | string                       | when not supplied by runner                           | A screenshot of the timer after a finished run. This is typically supplied automatically by timers which support auto-uploading runs to Splits I/O.                                                                                           |
| `created_at`              | string                       | never                                                 | The time and date at which this run's source file was uploaded to Splits I/O. This field conforms to [ISO 8601][iso8601].                                                                                                                     |
| `updated_at`              | string                       | never                                                 | The time and date at which this run was most recently modified on Splits I/O (modify events include disowning, adding a video or speedrun.com association, and changing the run's game/category). This field conforms to [ISO 8601][iso8601]. |
| `video_url`               | string                       | when not supplied by runner                           | A URL for a Twitch, YouTube, or Hitbox video which can be used as proof of the run. This is supplied by the runner.                                                                                                                           |
| `game`                    | [Game][game]                 | when unable to be determined / not supplied by runner | The game which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                           |
| `category`                | [Category][cagegory]         | when unable to be determined / not supplied by runner | The category which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                       |
| `runners`                 | array of [Runners][runner]   | never                                                 | The runner(s) who performed the run, if they claim credit.                                                                                                                                                                                    |
| `segments`                | array of [Segments][segment] | never                                                 | The associated segments for the run.                                                                                                                                                                                                          |

If a `historic=1` param is included in the request, one additional field will be present:

|       Field | Type                     | Null when... | Description                                                                                                                                                                                                                               |
|------------:|:-------------------------|:-------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `histories` | array of History objects | never        | Ordered history objects of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history. |

### Segment
Segment objects have the following format:

| Field                           | Type    | Can it be null? | Description                                                                                                                                                                                                                                                        |
|:--------------------------------|:--------|:----------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`                          | string  | never           | Name of the segment. This value is an exact copy of timers' fields.                                                                                                                                                                                                |
| `segment_number`                | number  | never           | The segment number of the run. (This value starts at 0)                                                                                                                                                                                                            |
| `realtime_start_ms`             | number  | never           | The total elapsed time of the run at the moment when this segment was started in realtime. Provided in milliseconds.                                                                                                                                               |
| `realtime_duration_ms`          | number  | never           | Realtime duration in milliseconds of the segment.                                                                                                                                                                                                                  |
| `realtime_end_ms`               | number  | never           | The total elapsed time of the run at the moment when this segment was finished in realtime (such that the run's duration is equal to the final split's finish time). Provided in milliseconds.                                                                     |
| `realtime_shortest_duration_ms` | number  | when not known  | The shortest duration the runner has ever gotten on this segment in realtime.  Provided in milliseconds                                                                                                                                                            |
| `realtime_gold`                 | boolean | never           | Whether or not this split *was* the shortest duration the runner has ever gotten on this segment in realtime. This field is shorthand for `realtime_duration_ms == realtime_shortest_duration_ms`.                                                                 |
| `realtime_skipped`              | boolean | never           | Whether or not this split was skipped in realtime -- some timers let the runner skip over a split in case they forgot to hit their split button on time. Beware that a skipped split's duration is considered `0`, and instead is rolled into the following split. |
| `realtime_reduced`              | boolean | never           | Whether or not this segment was "reduced" in realtime; that is, had its duration affected by previous splits being skipped.                                                                                                                                        |
| `gametime_start_ms`             | number  | never           | The total elapsed time of the run at the moment when this segment was started in gametime. Provided in milliseconds.                                                                                                                                               |
| `gametime_duration_ms`          | number  | never           | Gametime duration in milliseconds of the segment.                                                                                                                                                                                                                  |
| `gametime_end_ms`               | number  | never           | The total elapsed time of the run at the moment when this segment was finished in gametime (such that the run's duration is equal to the final split's finish time). Provided in milliseconds.                                                                     |
| `gametime_shortest_duration_ms` | number  | when not known  | The shortest duration the runner has ever gotten on this segment in gametime.  Provided in milliseconds                                                                                                                                                            |
| `gametime_gold`                 | boolean | never           | Whether or not this split *was* the shortest duration the runner has ever gotten on this segment in gametime. This field is shorthand for `duration == best`.                                                                                                      |
| `gametime_skipped`              | boolean | never           | Whether or not this split was skipped in gametime -- some timers let the runner skip over a split in case they forgot to hit their split button on time. Beware that a skipped split's duration is considered `0`, and instead is rolled into the following split. |
| `gametime_reduced`              | boolean | never           | Whether or not this segment was "reduced" in gametime; that is, had its duration affected by previous splits being skipped.                                                                                                                                        |

If a `historic=1` param is included in the request, one additional field will be present:

|       Field | Type                     | Null when... | Description                                                                                                                                                                                                                               |
|------------:|:-------------------------|:-------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `histories` | array of History objects | never        | Ordered history objects of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history. |

History objects have the following format.

| Field                  | Type   | Null when... | Description                                              |
|:-----------------------|:-------|:-------------|:---------------------------------------------------------|
| `attempt_number`       | number | never        | The correpsonding attempt number this attempt was.       |
| `realtime_duration_ms` | number | never        | The realtime duration this attempt took in milliseconds. |
| `gametime_duration_ms` | number | never        | The gametime duration this attempt took in milliseconds. |

A note when passing `historic=1` along with your request: Adding historical data to the response can take a long time to
render, so please only request it if you are actually using it. Be prepared for your request to time out for runs that
have a lot of historical information present.

If an `Accept` header is present, Splits I/O will try to render the run file in the format specified rather than JSON. A full list of valid values is located below.
If the `Accept` header is valid, the `Content-Type` header in the response will be set appropriately and the run will be rendered in the specified format. If
an invalid `Accept` header is supplied, the response `Content-Type` header will be `application/json`, and the status code will be a 406.
In the 406 reponse there will be an array of values that can be rendered.

| `Accept` Headers Supported       | Return Format              | Return `Content-Type`                 |
|:---------------------------------|:---------------------------|:--------------------------------------|
| None                             | JSON                       | `application/json`                    |
| `application/json`               | JSON                       | `application/json`                    |
| `application/splitsio`           | Splits I/O Exchange Format | `application/splitsio`                |
| `application/wsplit`             | WSplit                     | `application/wsplit`                  |
| `application/time-split-tracker` | Time Split Tracker         | `application/time-split-tracker`      |
| `application/splitterz`          | SplitterZ                  | `application/splitterz`               |
| `application/livesplit`          | LiveSplit                  | `application/livesplit`               |
| `application/urn`                | Urn                        | `application/urn`                     |
| `application/llanfair-gered`     | Llanfair-Gered             | `application/llanfair-gered`          |
| `application/original-timer`     | Original Run File          | One of the following `Content-Type`'s |

If the accept header is `application/original-timer` then the original file uploaded will be returned as is. Thus it is possible to get back
any of the following `Content-Type`s.
* `application/shitsplit`
* `application/splitty`
* `application/llanfair2`
* `application/facesplit`
* `application/portal-2-live-timer`
* `application/llanfair-gered`
* `application/llanfair`
* `application/urn`
* `application/livesplit`
* `application/source-live-timer`
* `application/splitsio`
* `application/splitterz`
* `application/time-split-tracker`
* `application/worstrun`
* `application/wsplit`

</details>

## Runner
<details>
<summary>Click to expand</summary>

```sh
curl https://splits.io/api/v4/runners?search=glacials
curl https://splits.io/api/v4/runners/glacials
curl https://splits.io/api/v4/runners/glacials/runs
curl https://splits.io/api/v4/runners/glacials/pbs
curl https://splits.io/api/v4/runners/glacials/games
curl https://splits.io/api/v4/runners/glacials/categories
```
A Runner is a user who has at least one run tied to their account. Users with zero runs are not discoverable using the
API.

| Field          | Type   | Can it be null? | Description                                                                                                                |
|:---------------|:-------|:----------------|:---------------------------------------------------------------------------------------------------------------------------|
| `twitch_id`    | string | never           | The numeric Twitch ID of the user.                                                                                         |
| `name`         | string | never           | The Twitch name of the user.                                                                                               |
| `display_name` | string | never           | The Twitch display name of the user.                                                                                       |
| `avatar`       | string | never           | The Twitch avatar of the user.                                                                                             |
| `created_at`   | string | never           | The time and date at which this user first authenticated with Splits I/O. This field conforms to [ISO 8601][iso8601].      |
| `updated_at`   | string | never           | The time and date at which this user was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601]. |

</details>

## Game
<details>
<summary>Click to expand</summary>

```sh
curl https://splits.io/api/v4/games?search=mario
curl https://splits.io/api/v4/games/sms
curl https://splits.io/api/v4/games/sms/categories
curl https://splits.io/api/v4/games/sms/runs
curl https://splits.io/api/v4/games/sms/runners
```
Most timers allow users to specify a "game" field. A Game is a collection of information about the video game specified
in this field. By definition, Games have at least one run and have an associated shortname, usually scraped from SRL or SRDC, but
sometimes specified manually.

| Field        | Type                            | Can it be null? | Description                                                                                                                          |
|:-------------|:--------------------------------|:----------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| `name`       | string                          | never           | The full title of the game, like "Super Mario Sunshine".                                                                             |
| `shortname`  | string                          | when not known  | A shortened title of the game, like "sms". Where possible, this name tries to match with those on SpeedRunsLive and/or Speedrun.com. |
| `created_at` | string                          | never           | The time and date at which this game was created on Splits I/O. This field conforms to [ISO 8601][iso8601].                          |
| `updated_at` | string                          | never           | The time and date at which this game was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601].           |
| `categories` | array of [Categories][category] | never           | The known speedrun categories for this game.                                                                                         |

</details>

## Category
<details>
<summary>Click to expand</summary>

```sh
curl https://splits.io/api/v4/categories/40
curl https://splits.io/api/v4/categories/40/runners
curl https://splits.io/api/v4/categories/40/runs
```
Some timers allow users to specify a "category" or similar field (any%, 100%, MST, etc.). A Category is a collection of
information about the type of run performed, more specific than a Game. Each Category belongs to a Game. Any number of
Categories can be associated with a Game.

| Field        | Type   | Can it be null? | Description                                                                                                                    |
|:-------------|:-------|:----------------|:-------------------------------------------------------------------------------------------------------------------------------|
| `id`         | string | never           | The numeric ID of the category.                                                                                                |
| `name`       | string | never           | The name of the category.                                                                                                      |
| `created_at` | string | never           | The time and date at which this category was created on Splits I/O. This field conforms to [ISO 8601][iso8601].                |
| `updated_at` | string | never           | The time and date at which this category was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601]. |

</details>

## Racing
<details>
<summary>Click to expand</summary>

Most racing endpoints will require authorization based on the flow described below in the
[authorization](#user-authentication-and-authorization) section.

`curl https://splits.io/api/v4/:type`
This endpoint is used to get a listing of all active raceables. Active races are unfinished raceables that have been
updated in the last 30 minutes or have at least 2 or more entrants.

`curl https://splits.io/api/v4/:type/:id`
This endpoint is used to get information about a specific race. To view information about secret races the `join_token`
parameter must also be provided.

| Status Codes | Success? | Body Present? | Description                                                                             |
|:-------------|:---------|:--------------|:----------------------------------------------------------------------------------------|
| 403          | No       | Yes           | This raceable is not viewable by the current user because they lack a valid join token. |
| 404          | No       | Yes           | No raceable found with the provided id.                                                 |
| 202          | Yes      | Yes           | Raceable schema will be returned.                                                       |

```sh
curl -X POST https://splits.io/api/v4/races \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"category_id":40,"notes":"Notes go here"}'
```

```sh
curl -X POST https://splits.io/api/v4/bingos \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"game_id":40,"card_url":"https://google.com","visibility":"secret"}'
```

```sh
curl -X POST https://splits.io/api/v4/randomizers \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"game_id":40,"notes":"Notes go here","seed":"asdfqweruiop"}'
```
This endpoint is used to create new raceables. All types can have notes, and patreons can change the visibility of a
race to either be `invite_only` or `secret`. Invite only is self explanitory, and secret raceables are ones where only
people with the `join_token` will be able to see any details about them. Join tokens are required to join either races,
and is provided in the response upon successful raceable creation. The only required parameter between all types is
the game/category that is going to be raced. Seed and bingo options can be changed after race creation as well.
*Note: races use categories, while bingos and randomizers use games*

| Status Codes | Success? | Body Present? | Description                                                                                                       |
|:-------------|:---------|:--------------|:------------------------------------------------------------------------------------------------------------------|
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                                        |
| 403          | No       | Yes           | Cannot create raceable with the desired visibility.                                                               |
| 400          | No       | Yes           | An error occured while creating the raceable, a human friendly error message will be returned in the `error` key. |
| 201          | Yes      | Yes           | Successfully created, a raceable schema will be returned.                                                         |

```sh
curl -X PATCH https://splits.io/api/v4/:type/:id
```
This endpoint is used to update bingo and randomizer attributes. For bingos this can be used to update the `card_url`
parameter. For randomizers this is used to add `attachments` to it (these should be seed files used in the race).

| Status Codes | Success? | Body Present? | Description                                                                                                     |
|:-------------|:---------|:--------------|:----------------------------------------------------------------------------------------------------------------|
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user or the owner of the bingo/randomizer. |
| 403          | No       | Yes           | The raceable has already been started and cannot be updated.                                                    |
| 406          | No       | Yes           | This is only returned when trying to update a regular category race.                                            |
| 400          | No       | Yes           | An error occured while saving the raceable, a human friendly error message will be returned in the `error` key. |
| 200          | Yes      | Yes           | Successfully update, a raceable schema will be returned.                                                        |

Races cannot be deleted, once they become inactive for 30 minutes they will naturally disappear from the listings.

Currently Splits.io supports 3 types of racing: Standard Category Race (Races), Bingos, and Randomizers.
All types have the following fields:

| Field           | Type                                   | Can it be null?                                 | Description                                                                                                                    |
|:----------------|:---------------------------------------|:------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------|
| `id`            | string                                 | never                                           | The string ID of the raceable.                                                                                                 |
| `type`          | string                                 | never                                           | The type of raceable: `race`, `bingo`, or `randomizer`.                                                                        |
| `path`          | string                                 | never                                           | The shortest slug for usage on the main site (passing the id will always work).                                                |
| `visibility`    | number                                 | never                                           | Who can see/join the race - 0: Public, 1: Invite Only, 2: Secret.                                                              |
| `join_token`    | string                                 | All times outside of raceable creation response | The token needed to join invite only and secret races. This is only non-null in the returned JSON when creating the race.      |
| `notes`         | string                                 | When no notes are provided                      | Any notes associatied with the raceable.                                                                                       |
| `started_at`    | string                                 | Before the race starts                          | The time and date at which this raceable was started on Splits I/O. This field conforms to [ISO 8601][iso8601].                |
| `created_at`    | string                                 | never                                           | The time and date at which this raceable was created on Splits I/O. This field conforms to [ISO 8601][iso8601].                |
| `updated_at`    | string                                 | never                                           | The time and date at which this raceable was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601]. |
| `owner`         | [Runner][runner]                       | never                                           | The user who created the race.                                                                                                 |
| `entrants`      | array of [Entrants][entrant]           | never                                           | All entrants currently in the raceable.                                                                                        |
| `chat_messages` | array of [Chat Messages][chat-message] | never                                           | Chat messages for the race. These will only be populated on `https://splits.io/api/v4/:type/:id`                               |

Race's have the following extra field:

| Field      | Type                 | Can it be null? | Description                       |
|:-----------|:---------------------|:----------------|:----------------------------------|
| `category` | [Category][category] | never           | The category that is being raced. |

Bingo's will have the following extra field:

| Field      | Type         | Can it be null?              | Description                                |
|:-----------|:-------------|:-----------------------------|:-------------------------------------------|
| `game`     | [Game][game] | never                        | The game the bingo is attached to.         |
| `card_url` | string       | When no URL has been set yet | The URL that the bingo card is located at. |

Randomizer's will have the following extra fields:

| Field         | Type                 | Can it be null? | Description                                        |
|:--------------|:---------------------|:----------------|:---------------------------------------------------|
| `game`        | [Game][game]         | never           | The game the bingo is attached to.                 |
| `seed`        | string               | if none is set  | The seed name associatied with the randomizer.     |
| `attachments` | array of Attachments | never           | Any attachments needed to complete the randomizer. |

Attachments have the following structure:

| Field        | Type   | Can it be null? | Description                                                                                                       |
|:-------------|:-------|:----------------|:------------------------------------------------------------------------------------------------------------------|
| `id`         | string | never           | The id of the attachment.                                                                                         |
| `created_at` | string | never           | The time and date at which this attachment was created on Splits I/O. This field conforms to [ISO 8601][iso8601]. |
| `filename`   | string | never           | The filename of the attachment.                                                                                   |
| `url`        | string | never           | The URL in which to download the attachment.                                                                      |

### Entrant
Entrants are inferred from the oauth token that is passed to the request. The GET endpoint will allow you to check
wether you are in the current raceable.

All endpoints check the presence and validity of the access token provided. If it is missing, invalid, or doesn't
belong to a user a 401 status with no body will be returned.

`curl -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/:type/:id/entrant`
Use this endpoint in order to find out if the user you are representing is current entered in the raceable.

| Possible Status Codes | Success? | Body Present? | Description                                                               |
|:----------------------|:---------|:--------------|:--------------------------------------------------------------------------|
| 401                   | No       | No            | Access token is either blank, expired, invalid, or not attached to a user |
| 404                   | No       | Yes           | There is no entrant for the user associated with the access token         |
| 200                   | Yes      | Yes           | An etrant schema will be returned.                                        |

`curl -X PUT -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/:type/:id/entrant`
Use this endpoint in order to join the raceable. If the raceable is invite only or secret a required parameter
`join_token` must be passed in as well.

| Status Codes | Success? | Body Present? | Description                                                                                                      |
|:-------------|:---------|:--------------|:-----------------------------------------------------------------------------------------------------------------|
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                                       |
| 403          | No       | Yes           | This raceable is not joinable by the current user because they lack a valid join token.                          |
| 400          | No       | Yes           | An error occured while creating the entrant, a human friendly error message will be returned in the `error` key. |
| 201          | Yes      | Yes           | Successfully created, an entrant schema will be returned.                                                        |

```sh
curl -X PATCH https://splits.io/api/v4/:type/:id/entrant \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json'
  -d '{"readied_at":"2019-06-17T03:40:48.123Z"'
```
Use this endpoint in order to update your entrant. Valid parameters are `readied_at`, `finished_at`, and
`forfeited_at`. Valid values are either an iso8601 compliant timestamp (with up to 3 decimal places of precision),
the string `now`, or `null`. Please use JSON encoding in order to properly pass `null`. When passing a timestamp that
will be used for the time, while passing `now` will use a timestamp taken as soon as possible in the request.
*Note: Join tokens are not required if the user is already in the race, but if they leave they must be provided again*

| Status Codes | Success? | Body Present? | Description                                                                                                      |
|:-------------|:---------|:--------------|:-----------------------------------------------------------------------------------------------------------------|
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                                       |
| 404          | No       | Yes           | No entrant found for the associated user.                                                                        |
| 400          | No       | Yes           | An error occured while updating the entrant, a human friendly error message will be returned in the `error` key. |
| 200          | Yes      | Yes           | Successfully updated, an entrant schema will be returned.                                                        |

`curl -X DELETE -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/:type/:id/entrant`
Use this endpoint in order to part from the race before it starts. If a race has started please use the above endpoint
and set the `forfeited_at` parameter accordingly.

| Status Codes | Success? | Body Present? | Description                                                                                                      |
|:-------------|:---------|:--------------|:-----------------------------------------------------------------------------------------------------------------|
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                                       |
| 404          | No       | Yes           | No entrant found for the associated user.                                                                        |
| 409          | No       | Yes           | An error occured while deleting the entrant, a human friendly error message will be returned in the `error` key. |
| 205          | Yes      | No            | Successfully deleted.                                                                                            |


Entrants have the following fields:

| Field          | Type             | Can it be null                                     | Description                                                                                                                   |
|:---------------|:-----------------|:---------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------|
| `readied_at`   | string           | when the entrant isn't ready                       | The time and date at which this entrant readied up in the raceable. This field conforms to [ISO 8601][iso8601].               |
| `finished_at`  | string           | when the etrant has not completed in the raceable  | The time and date at which this entrant completed this raceable. This field conforms to [ISO 8601][iso8601].                  |
| `forfeited_at` | string           | when the entrant has not forfeited in the raceable | The time and date at which this entrant forfeited from this raceable. This field conforms to [ISO 8601][iso8601].             |
| `created_at`   | string           | never                                              | The time and date at which this entrant was created on Splits I/O. This field conforms to [ISO 8601][iso8601].                |
| `updated_at`   | string           | never                                              | The time and date at which this entrant was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601]. |
| `user`         | [Runner][runner] | never                                              | The user that is participating in this raceable.                                                                              |

### Chat Message
`curl https://splits.io/api/v4/:type/:id/chat`
This endpoint will return a paginated array of all the chat messages, starting with the newest ones first.

```sh
curl -X POST https://splits.io/api/v4/:type/:id/chat \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"body":"a message body here"}'
```
This endpoint is used to create new messages for the given raceable. The user and entrant fields will be inferred, so
only pass in a body parameter which should contain the message that you wish to post.

Chat messages will have the following fields:

| Field        | Type             | Can it be null | Description                                                                                                                   |
|:-------------|:-----------------|:---------------|:------------------------------------------------------------------------------------------------------------------------------|
| `body`       | string           | never          | The contents of the message.                                                                                                  |
| `entrant`    | boolean          | never          | Boolean indicating wether the sender was in the race when the message was sent.                                               |
| `created_at` | string           | never          | The time and date at which this message was created on Splits I/O. This field conforms to [ISO 8601][iso8601].                |
| `updated_at` | string           | never          | The time and date at which this message was most recently modified on Splits I/O. This field conforms to [ISO 8601][iso8601]. |
| `user`       | [Runner][runner] | never          | The runner that sent the message.                                                                                             |

</details>

## Uploading
<details>
<summary>Click to expand</summary>

```sh
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
```sh
curl -X POST https://s3.amazonaws.com/splits.io \
  --form key="splits/rez" \
  --form policy="gibberish" \
  --form x-amz-credential="other gibberish" \
  --form x-amz-algorithm="more gibberish" \
  --form x-amz-date="even more gibberish" \
  --form x-amz-signature="most gibberish" \
  --form file='Your run here, e.g. a JSON object if using the Splits.io Exchange Format'
```
Or if your run is a file on disk, the last line would be:
```
  --form file=@/path/to/file
```
**Note**: Order of the parameters matters! Follow the order above if you're getting errors.

This is called a presigned request. Each field above -- except `file`, that's yours -- is directly copied from the
response of the first request. You don't need to inspect or care about the contents of the fields, as long as you
include them. They serve as authorization for you to upload a file to S3 with Splits I/O's permission.

Each presigned request can only be made once, and expires if not made within an hour.

[s3]: https://aws.amazon.com/s3

### File Format
The preferred format for uploading run files is the [Splits I/O Exchange Format][exchange-format], which is a standard
JSON schema not specific to any one timer. Splits I/O also knows how to parse some proprietary timer formats via
livesplit-core, all documented in the [FAQ][faq].

[exchange-format]: /public/schema
[faq]: https://splits.io/faq#programs

</details>

## User Authentication and Authorization
<details>
<summary>Click to expand</summary>

If you want to upload, disown, or delete runs for a user (e.g. from within a timer), you have two options.
If you only need to know who a user is on Splits I/O, skip to advanced.

### Simple Option
Upload the run without auth and direct the user to the URL in the response body's `uris.claim_uri`. If they are logged
in when they visit it, their account will automatically claim the run. If they are not logged in, their browser will
save the claim token in LocalStorage and show a prompt allowing them to claim the run after logging in, immediately or
at any later time.

This is the far easier method to implement, but the user must open the run in their web browser for it to become theirs.
If you prefer to upload runs in the background, this method isn't for you.

### Advanced Option
The advanced option is a standard OAuth2 flow. You can request permission from the user to upload runs to their account
on their behalf. If they accept, you will receive an OAuth token which you can include in your run requests in
order to perform actions as that user.

The following instructions go into naive-case details about implementing this OAuth support in your application. If you
want to learn more about OAuth or need general OAuth troubleshooting help, you can [research OAuth2
online][oauth2-simplified]. Especially if your application is a website, it's likely that the language you're using has
well-established libraries that handle much of the below OAuth flow for you.

In all cases, you'll need to first go to your Splits I/O account's [settings page][1] and create an application, then
refer to the relevant section below.

*Note: Once you have an OAuth token, you can use a request like this to retrieve information about it:*
```http
GET https://splits.io/oauth/token/info?access_token=YOUR_TOKEN
```

[oauth2-simplified]: https://aaronparecki.com/oauth-2-simplified/

#### Scopes
Below is a list of all the possible scopes your application can request along with a brief description. You can specify
multiple scopes by separating them with spaces in the auth token request.

| Scope         | Description                                         | Endpoints                                                                                                           |
|:--------------|:----------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------|
| `upload_run`  | Upload runs on behalf of the user                   | `POST https://splits.io/api/v4/runs`                                                                                |
| `delete_run`  | Delete or disown runs on behalf of the user         | `DELETE https://splits.io/api/v4/runs/:run_id` and `DELETE https://splits.io/api/v4/runs/:run_id/user` respectively |
| `manage_race` | Participate in races and chat on behalf of the user | Endpoints here                                                                                                      |

#### Example 1: My application is a local program that runs on the user's computer
If your application runs locally as a program on a user's computer, you should use OAuth's **authorization code grant
flow**. This means your application will open the Splits I/O authorization page in the user's default browser, and if
the user accepts the authorization, Splits I/O will give your application a `code` which you should immediately exchange
for an OAuth token using a secure API request.

1. Configure your program to run a small web server on a port of your choosing, and listen for `GET` requests to a path
    of your choosing. In this example, let's say you're listening on port 8000 for requests to `/auth/splitsio`.
2. On your Splits I/O [settings page][1], set your `redirect_uri` to something like
    ```http
    http://localhost:8000/auth/splitsio
    ```
    *Hint: Set this to "debug" for now if you don't yet have a page to redirect yourself to.*
3. When a user wants to grant authorization to your application for their Splits I/O account, send them to a URL like
    this:
    ```http
    https://splits.io/oauth/authorize?response_type=code&scope=upload_run&redirect_uri=http://localhost:8000/auth/splitsio&client_id=YOUR_CLIENT_ID
    ```
    If the user authorizes your application, they will be redirected to a URL like
    ```http
    http://localhost:8000/auth/splitsio?code=YOUR_CODE
    ```
    which the web server you set up in step 1 should respond to. Give the user a nice-looking HTML page saying to switch
    back to the application and strip the `code` URL parameter for the next step.
4. Use your `code` to make this request:
    ```http
    POST https://splits.io/oauth/token
    ```
    with this body:
    ```http
    grant_type=authorization_code
    client_id=YOUR_CLIENT_ID
    client_secret=YOUR_CLIENT_SECRET
    code=YOUR_CODE
    redirect_uri=http://localhost:8000/auth/splitsio
    ```
    which will respond with something like this:
    ```json
    {
      "access_token": "0e82e0ac69fed3c6e5044682a9eb94ccded5ace70e84838104a131cb50595cd2",
      "token_type": "bearer",
      "expires_in": 7200,
      "refresh_token": "0e23b095e0d0104ff0642cde71b61d236f3b3865734a0e734714ecd45b25106c",
      "scope": "upload_run",
      "created_at": 1499314941
    }
    ```
    Success! `access_token` is your OAuth token for the user. Use it in your API requests to act on behalf of the user
    by including this header in your requests:
    ```http
    Authorization: Bearer YOUR_ACCESS_TOKEN
    ```
    or by including an `access_token=YOUR_ACCESS_TOKEN` parameter.

    The access token expires after the duration specified in `expires_in` (measured in seconds). After it expires, you
    can retrieve a new one with no user intervention using the returned `refresh_token`:
    ```http
    POST https://splits.io/oauth/token
    ```
    ```http
    grant_type=refresh_token
    refresh_token=YOUR_REFRESH_TOKEN
    client_id=YOUR_CLIENT_ID
    client_secret=YOUR_CLIENT_SECRET
    ```
    This will return a new access token (and a new refresh token -- update yours!) in a body format identical to
    original grant (above).

    This style of expiring access tokens periodically and using refresh tokens to replace them improves security by
    making it obvious when a user's stolen credentials are in use. See [RFC 6749][rfc6749-6] for more information on
    refresh tokens.

#### Example 2: My application is an all-JavaScript website
If your application is an in-browser JavaScript application with little or no logic performed by a backend server, you
should use OAuth's **implicit grant flow**.

1. On your Splits I/O [settings page][1], set your `redirect_uri` to where you want users to land after going through
   the authorization flow. For this example, we'll use
    ```http
    https://YOUR_WEBSITE/auth/splitsio
    ```
    *Hint: Set this to "debug" for now if you don't yet have a page to redirect yourself to.*
2. When a user wants to grant authorization to your application for their Splits I/O account, send them to a URL like
    this:
    ```http
    https://splits.io/oauth/authorize?response_type=token&scope=upload_run&redirect_uri=https://YOUR_WEBSITE/auth/splitsio&client_id=YOUR_CLIENT_ID
    ```
    If the user authorizes your application, they will be redirected to a URL like
    ```http
    https://YOUR_WEBSITE/auth/splitsio#access_token=YOUR_TOKEN
    ```
    Success! `access_token` is your OAuth token for the user. Use it in your API requests to act on behalf of the user
    by including this header in your requests:
    ```http
    Authorization: Bearer YOUR_ACCESS_TOKEN
    ```
    The access token expires after the duration specified in `expires_in` (measured in seconds). After it expires, you
    can retrieve a new one with no user intervention using redirection upon accessing your app, or a hidden iframe to
    invisibly take the user through the authorization flow. If the user is still authorized, no user interaction will be
    required and you can strip your new access token from the URL fragment.

    This style of expiring access tokens periodically improves security by limiting the usability of any stolen
    credentials.

#### Example 3: My application is a website
If your application is a website with a backend component, you should use OAuth's **authorization code grant flow**.
This means your website will link the user to the Splits I/O authorization page, and if the user accepts the
authorization, Splits I/O will give your application a `code` which it will immediately exchange for an OAuth token
using a secure API request.

1. On your Splits I/O [settings page][1], set your `redirect_uri` to where you want users to land after going through
   the authorization flow. For this example, we'll use
    ```http
    https://YOUR_WEBSITE/auth/splitsio
    ```
    *Hint: Set this to "debug" for now if you don't yet have a page to redirect yourself to.*
2. When a user wants to grant authorization to your application for their Splits I/O account, send them to a URL like
    this:
    ```http
    https://splits.io/oauth/authorize?response_type=code&scope=upload_run&redirect_uri=https://YOUR_WEBSITE/auth/splitsio&client_id=YOUR_CLIENT_ID
    ```
    If the user authorizes your application, they will be redirected to a URL like
    ```http
    https://YOUR_WEBSITE/auth/splitsio?code=YOUR_CODE
    ```
    Strip the `code` URL parameter for the next step.
4. Use your `code` to make this request:
    ```http
    POST https://splits.io/oauth/token
    ```
    with this body:
    ```http
    grant_type=authorization_code
    client_id=YOUR_CLIENT_ID
    client_secret=YOUR_CLIENT_SECRET
    code=YOUR_CODE
    redirect_uri=http://localhost:8000/auth/splitsio
    ```
    which will respond with something like this:
    ```json
    {
      "access_token": "0e82e0ac69fed3c6e5044682a9eb94ccded5ace70e84838104a131cb50595cd2",
      "token_type": "bearer",
      "expires_in": 7200,
      "refresh_token": "0e23b095e0d0104ff0642cde71b61d236f3b3865734a0e734714ecd45b25106c",
      "scope": "upload_run",
      "created_at": 1499314941
    }
    ```
    Success! `access_token` is your OAuth token for the user. Use it in your API requests to act on behalf of the user
    by including this header in your requests:
    ```http
    Authorization: Bearer YOUR_ACCESS_TOKEN
    ```
    The access token expires after the duration specified in `expires_in` (measured in seconds). After it expires, you
    can retrieve a new one with no user intervention using the returned `refresh_token`:
    ```http
    POST https://splits.io/oauth/token
    ```
    ```http
    grant_type=refresh_token
    refresh_token=YOUR_REFRESH_TOKEN
    client_id=YOUR_CLIENT_ID
    client_secret=YOUR_CLIENT_SECRET
    ```
    This will return a new access token (and a new refresh token -- update yours!) in a body format identical to
    original grant (above).

    This style of expiring access tokens periodically and using refresh tokens to replace them improves security by
    making it obvious when a user's stolen credentials are in use. See [RFC 6749][rfc6749-6] for more information on
    refresh tokens.

[1]: https://splits.io/settings
[rfc6749-6]: https://tools.ietf.org/html/rfc6749#section-6

</details>

## Converting
<details>
<summary>Click to expand</summary>

```sh
curl -X POST https://splits.io/api/v4/convert?format=livesplit --form file=@/path/to/file
```
When converting between timer formats, the file and program parameters must be included. If you are converting a
LiveSplit file and would like to include the history, then the `historic=1` parameter can also be included.  The JSON
format is outputted as described above in the form of a .json file.

</details>

## FAQ
<details>
<summary>Click to expand</summary>

### Why are IDs strings?
IDs are opaque. To you, the consumer, it doesn't matter what the actual number itself is because the only purpose it
serves is be given back to Splits I/O later. You don't need to look inside it, you don't need to perform arithmetic on
it, you don't need it rounded or floored or rid of leading zeroes. You don't need to do any numbery things to them. And
in fact if you do do numbery things to them, even accidentally, there's a good chance you've broken them in the process.

It doesn't matter that on Splits I/O's end they happen to be auto-incrementing base 10 numbers, because none of that
matters to you. By giving you a number type, we'd be implying that it did. Strings are opaque. Strings are what you'd
end up casting your IDs to anyway in order to hit the API with them again. So let's just take the negligible hit and
save you a step.

</details>


[iso8601]: https://en.wikipedia.org/wiki/ISO_8601

[run]: #run
[segment]: #segment
[runner]: #runner
[game]: #game
[category]: #category
[uploading]: #uploading
[racing]: #racing
[entrant]: #entrant
[chat-message]: #chat-message
