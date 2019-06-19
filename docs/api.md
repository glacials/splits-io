# API v4
The Splits.io API supports retrieving runs, runners, games, and categories, as well as uploading, disowning, and deleting
runs and managing races.

## IDs
Resources are identifiable by the following attributes:

| Resource type        | Key attribute | Type   | Description     | Value example(s)                                |
|:---------------------|:--------------|:-------|:----------------|:------------------------------------------------|
| [Run][run]           | ID            | String | Base 36 number  | `"1b"` `"3nm"` `"1vr"`                          |
| [Runner][runner]     | Name          | String | Twitch username | `"glacials"` `"batedurgonnadie"` `"snarfybobo"` |
| [Game][game]         | Shortname     | String | Shortname       | `"sms"` `"sm64"` `"portal"`                     |
| [Category][category] | ID            | String | Base 10 number  | `"312"` `"1456"` `"11"`                         |
| [Raceable][raceable] | ID            | String | UUID            | `"c198a25f-9f8a-43cd-92ab-472a952f9336"`        |
| [Entrant][entrant]   | ID            | String | UUID            | `"61db2b30-e024-45c5-b188-e9986ff1c89c"`        |

Your code shouldn't care too much about what these attributes actually are. They're all represented as opaque
unique strings.

<details>
<summary>Why are even numerical IDs strings?</summary>

IDs are opaque, and string is a more opaque primitive. It doesn't matter what the actual value is because the only
purpose it
serves is be given back to Splits.io later (as a string!) or to be compared for exact equality to another ID.

You don't need to look inside the ID, perform arithmetic on it, round it, floor it, rid it of leading zeroes, or convert
it between a float and an integer. You don't need to do any numbery things to it. And if you do, you've probably broken
it. It's a negligible hit to store them as strings, and you'd be converting them to strings for use in API requests
anyway.
</details>

**Note**: In the below documentation, a path component like `:run` is a substitution for a real run ID.

## Authentication & authorization

### Simple auth (run uploads only)
If the only thing you need to do on behalf of users is upload runs, you can do so anonymously then send the user to the
"claim URI" in the response's `uris.claim_uri` field. Sending a logged-in user here will cause the run to be claimed to
their account. Sending a logged-out user here will save the secret to browser local storage and prompt the user to sign
in to claim the run. They may do so immediately or at any later time.

The user must open the claim URI in their web browser for it to become theirs. If you need to upload runs without this
user intervention or want to do more with auth than uploading runs, use the OAuth option.

### OAuth (general purpose)
Splits.io supports the standard OAuth2 flow. You can request permission from the user to upload runs to their account or
perform other actions on their behalf. If they accept, you will receive an OAuth token which you can include in your API
requests in order to perform actions as that user.

The following instructions go into naive-case details about implementing this OAuth support in your application. If you
want to learn more about OAuth or need general OAuth troubleshooting help, you can
[research OAuth2 online][oauth2-simplified]. Especially if your application is a website, it's likely that the language
you're using has well-established libraries that handle much of the below OAuth flow for you. Look into those solutions
first to take the gruntwork out.

In all cases, you'll need to first go to your Splits.io account's [settings page][1] and create an application, then
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
| `manage_race` | Participate in races and chat on behalf of the user | See [Race][race]                                                                                                    |

<details>
<summary>Example 1: My application is a local program that runs on the user's computer</summary>

If your application runs locally as a program on a user's computer, you should use OAuth's **authorization code grant
flow**. This means your application will open the Splits.io authorization page in the user's default browser, and if the
user accepts the authorization, Splits.io will give your application a `code` which you should immediately exchange for
an OAuth token using a secure API request.

1. Configure your program to run a small web server on a port of your choosing, and listen for `GET` requests to a path
    of your choosing. In this example, let's say you're listening on port 8000 for requests to `/auth/splitsio`.
2. On your Splits.io [settings page][1], set your `redirect_uri` to something like
    ```http
    http://localhost:8000/auth/splitsio
    ```
    *Hint: Set this to "debug" for now if you don't yet have a page to redirect yourself to.*
3. When a user wants to grant authorization to your application for their Splits.io account, send them to a URL like
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

</details>

<details>
<summary>Example 2: My application is an all-JavaScript website</summary>

If your application is an in-browser JavaScript application with little or no logic performed by a backend server, you
should use OAuth's **implicit grant flow**.

1. On your Splits.io [settings page][1], set your `redirect_uri` to where you want users to land after going through
   the authorization flow. For this example, we'll use
    ```http
    https://YOUR_WEBSITE/auth/splitsio
    ```
    *Hint: Set this to "debug" for now if you don't yet have a page to redirect yourself to.*
2. When a user wants to grant authorization to your application for their Splits.io account, send them to a URL like
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
</details>

<details>
<summary>Example 3: My application is a website</summary>

If your application is a website with a backend component, you should use OAuth's **authorization code grant flow**.
This means your website will link the user to the Splits.io authorization page, and if the user accepts the
authorization, Splits.io will give your application a `code` which it will immediately exchange for an OAuth token using
a secure API request.

1. On your Splits.io [settings page][1], set your `redirect_uri` to where you want users to land after going through
   the authorization flow. For this example, we'll use
    ```http
    https://YOUR_WEBSITE/auth/splitsio
    ```
    *Hint: Set this to "debug" for now if you don't yet have a page to redirect yourself to.*
2. When a user wants to grant authorization to your application for their Splits.io account, send them to a URL like
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
[race]: #race
</details>

## Resource types
### Run

```sh
curl https://splits.io/api/v4/runs/:run
curl https://splits.io/api/v4/runs/:run?historic=1
```
A Run maps 1:1 to an uploaded splits file.

<details>
<summary>Structure of a Run</summary>

| Field                     | Type                         | Null?                                                 | Description                                                                                                                                                                                                                                  |
|:--------------------------|:-----------------------------|:------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`                      | string                       | never                                                 | Unique ID for identifying the run on Splits.io. This can be used to construct a user-facing URL or an API-facing one.                                                                                                                        |
| `srdc_id`                 | string                       | when no associated speedrun.com run                   | Unique ID for identifying the run on speedrun.com. This is typically supplied by the runner manually.                                                                                                                                        |
| `realtime_duration_ms`    | number                       | never                                                 | Realtime duration in milliseconds of the run.                                                                                                                                                                                                |
| `realtime_sum_of_best_ms` | number                       | never                                                 | Realtime sum of best in milliseconds of the run.                                                                                                                                                                                             |
| `gametime_duration_ms`    | number                       | never                                                 | Gametime duration in milliseconds of the run.                                                                                                                                                                                                |
| `gametime_sum_of_best_ms` | number                       | never                                                 | Gametime sum of best in milliseconds of the run.                                                                                                                                                                                             |
| `default_timing`          | string                       | never                                                 | The timing used for the run.  Will be either `real` or `game`.                                                                                                                                                                               |
| `program`                 | string                       | never                                                 | The name of the timer with which the run was recorded. This is typically an all lowercase, no-spaces version of the program name.                                                                                                            |
| `attempts`                | number                       | when not supported by the source timer                | The number of run attempts recorded by the timer that generated the run's source file.                                                                                                                                                       |
| `image_url`               | string                       | when not supplied by runner                           | A screenshot of the timer after a finished run. This is typically supplied automatically by timers which support auto-uploading runs to Splits.io.                                                                                           |
| `created_at`              | string                       | never                                                 | The time and date at which this run's source file was uploaded to Splits.io. This field conforms to [ISO 8601][iso8601].                                                                                                                     |
| `updated_at`              | string                       | never                                                 | The time and date at which this run was most recently modified on Splits.io (modify events include disowning, adding a video or speedrun.com association, and changing the run's game/category). This field conforms to [ISO 8601][iso8601]. |
| `video_url`               | string                       | when not supplied by runner                           | A URL for a Twitch, YouTube, or Hitbox video which can be used as proof of the run. This is supplied by the runner.                                                                                                                          |
| `game`                    | [Game][game]                 | when unable to be determined / not supplied by runner | The game which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                          |
| `category`                | [Category][cagegory]         | when unable to be determined / not supplied by runner | The category which was run. An attempt is made at autodetermining this from the source file, but it can be later changed by the runner.                                                                                                      |
| `runners`                 | array of [Runners][runner]   | never                                                 | The runner(s) who performed the run, if they claim credit.                                                                                                                                                                                   |
| `segments`                | array of [Segments][segment] | never                                                 | The associated segments for the run.                                                                                                                                                                                                         |

If a `historic=1` param is included in the request, one additional field will be present:

|       Field | Type                     | Null? | Description                                                                                                                                                                                                                               |
|------------:|:-------------------------|:------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `histories` | array of History objects | never | Ordered history objects of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history. |

#### Segment
Segment objects have the following format:

| Field                           | Type    | Null?          | Description                                                                                                                                                                                                                                                        |
|:--------------------------------|:--------|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`                          | string  | never          | Name of the segment. This value is an exact copy of timers' fields.                                                                                                                                                                                                |
| `segment_number`                | number  | never          | The segment number of the run. (This value starts at 0)                                                                                                                                                                                                            |
| `realtime_start_ms`             | number  | never          | The total elapsed time of the run at the moment when this segment was started in realtime. Provided in milliseconds.                                                                                                                                               |
| `realtime_duration_ms`          | number  | never          | Realtime duration in milliseconds of the segment.                                                                                                                                                                                                                  |
| `realtime_end_ms`               | number  | never          | The total elapsed time of the run at the moment when this segment was finished in realtime (such that the run's duration is equal to the final split's finish time). Provided in milliseconds.                                                                     |
| `realtime_shortest_duration_ms` | number  | when not known | The shortest duration the runner has ever gotten on this segment in realtime.  Provided in milliseconds                                                                                                                                                            |
| `realtime_gold`                 | boolean | never          | Whether or not this split *was* the shortest duration the runner has ever gotten on this segment in realtime. This field is shorthand for `realtime_duration_ms == realtime_shortest_duration_ms`.                                                                 |
| `realtime_skipped`              | boolean | never          | Whether or not this split was skipped in realtime -- some timers let the runner skip over a split in case they forgot to hit their split button on time. Beware that a skipped split's duration is considered `0`, and instead is rolled into the following split. |
| `realtime_reduced`              | boolean | never          | Whether or not this segment was "reduced" in realtime; that is, had its duration affected by previous splits being skipped.                                                                                                                                        |
| `gametime_start_ms`             | number  | never          | The total elapsed time of the run at the moment when this segment was started in gametime. Provided in milliseconds.                                                                                                                                               |
| `gametime_duration_ms`          | number  | never          | Gametime duration in milliseconds of the segment.                                                                                                                                                                                                                  |
| `gametime_end_ms`               | number  | never          | The total elapsed time of the run at the moment when this segment was finished in gametime (such that the run's duration is equal to the final split's finish time). Provided in milliseconds.                                                                     |
| `gametime_shortest_duration_ms` | number  | when not known | The shortest duration the runner has ever gotten on this segment in gametime.  Provided in milliseconds                                                                                                                                                            |
| `gametime_gold`                 | boolean | never          | Whether or not this split *was* the shortest duration the runner has ever gotten on this segment in gametime. This field is shorthand for `duration == best`.                                                                                                      |
| `gametime_skipped`              | boolean | never          | Whether or not this split was skipped in gametime -- some timers let the runner skip over a split in case they forgot to hit their split button on time. Beware that a skipped split's duration is considered `0`, and instead is rolled into the following split. |
| `gametime_reduced`              | boolean | never          | Whether or not this segment was "reduced" in gametime; that is, had its duration affected by previous splits being skipped.                                                                                                                                        |

If a `historic=1` param is included in the request, one additional field will be present:

|       Field | Type                     | Null? | Description                                                                                                                                                                                                                               |
|------------:|:-------------------------|:------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `histories` | array of History objects | never | Ordered history objects of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history. |

#### History
History objects have the following format.

| Field                  | Type   | Null? | Description                                              |
|:-----------------------|:-------|:------|:---------------------------------------------------------|
| `attempt_number`       | number | never | The correpsonding attempt number this attempt was.       |
| `realtime_duration_ms` | number | never | The realtime duration this attempt took in milliseconds. |
| `gametime_duration_ms` | number | never | The gametime duration this attempt took in milliseconds. |
</details>

<details>
<summary>Getting runs in specific formats</summary>
Splits.io can render many different formats other than JSON. To get one, pass an Accept header with the format you want.

| `Accept` Headers Supported       | Return Format             | Return `Content-Type`                 |
|:---------------------------------|:--------------------------|:--------------------------------------|
| None                             | JSON                      | `application/json`                    |
| `application/json`               | JSON                      | `application/json`                    |
| `application/splitsio`           | Splits.io Exchange Format | `application/splitsio`                |
| `application/wsplit`             | WSplit                    | `application/wsplit`                  |
| `application/time-split-tracker` | Time Split Tracker        | `application/time-split-tracker`      |
| `application/splitterz`          | SplitterZ                 | `application/splitterz`               |
| `application/livesplit`          | LiveSplit                 | `application/livesplit`               |
| `application/urn`                | Urn                       | `application/urn`                     |
| `application/llanfair-gered`     | Llanfair-Gered            | `application/llanfair-gered`          |
| `application/original-timer`     | Original Run File         | One of the following `Content-Type`'s |

If the Accept header is `application/original-timer`, the source file for the run will be returned as-is, in whatever
type it was in at the time of upload. This may even be a format not listed above, as Splits.io can recognize and parse
some types that it can't convert into. In only this case, the Content-Type may be one of these addditional values:

* `application/shitsplit`
* `application/splitty`
* `application/llanfair2`
* `application/facesplit`
* `application/portal-2-live-timer`
* `application/llanfair`
* `application/source-live-timer`
* `application/worstrun`
</details>

<details>
<summary>Uploading runs</summary>

```sh
curl -X POST https://splits.io/api/v4/runs # then...
curl -X POST https://s3.amazonaws.com/splits.io --form file=@/path/to/file # some fields not shown; see below
```
Uploading runs is a two-step process. Splits.io stores runs on [S3][s3], so in the first request you'll tell Splits.io
you're about to upload a run, then in the second you'll upload it directly to S3 using some parameters returned from the
first. The two-request system is faster for you (the run is transferred once, not twice) and more resilient for us.

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
      "x-amz-signature": "most gibberish"
    }
  }
}
```
The above example would have your second request look like
```sh
# Uploads must be multipart requests (in curl: -F or --form, NOT -d or --data)
curl -X POST https://s3.amazonaws.com/splits.io \
  --form key="splits/rez" \
  --form policy="gibberish" \
  --form x-amz-credential="other gibberish" \
  --form x-amz-algorithm="more gibberish" \
  --form x-amz-date="even more gibberish" \
  --form x-amz-signature="most gibberish" \
  --form file='Your run here, e.g. a JSON object if using the Splits.io Exchange Format'
```
Or if your run is a file on disk, the last line would instead be:
```
  --form file=@/path/to/file
```
**Note**: Parameter order matters! Follow the order above if you're getting errors.

This is called a presigned request. Each field above except `file` is directly copied from the response of the first
request. You don't need to care about the contents of the fields; they serve as authorization for you to upload a file
to S3. Each presigned request can only be made once.

[s3]: https://aws.amazon.com/s3

#### File Format
The preferred format for uploading run files is the [Splits.io Exchange Format][exchange-format], which is a standard
JSON schema not specific to any one timer. Splits.io also knows how to parse some proprietary timer formats via
livesplit-core, documented in the [FAQ][faq].

[exchange-format]: /public/schema
[faq]: https://splits.io/faq#programs

#### Replacing source files
Occasionally you may want to update an existing run's source file to a newer version, such as when a runner splits and
you are reporting splits in realtime (like in a race). You can do this using the same two-request system as above but
changing your method and path to
```http
PUT https://splits.io/api/v4/run/:run/source_file
```
and following the same steps as above to upload to S3. Splits.io will automatically parse the new file and update the
run.

**Note**: When uploading in-progress source files in the Splits.io Exchange Format include all splits as normal, but do
not include the `endedAt` field for unreached segments.
</details>

<details>
<summary>Converting runs</summary>

```sh
# Uploads must be multipart requests (-F or --form, not -d or --data)
curl -X POST https://splits.io/api/v4/convert?format=livesplit --form file=@/path/to/file
```
When converting between timer formats, the file and program parameters must be included. If you are converting a
LiveSplit file and would like to include the history, then the `historic=1` parameter can also be included.  The JSON
format is outputted as described above in the form of a .json file.

</details>

### Runner
```sh
curl https://splits.io/api/v4/runners?search=:runner
curl https://splits.io/api/v4/runners/:runner
curl https://splits.io/api/v4/runners/:runner/runs
curl https://splits.io/api/v4/runners/:runner/pbs
curl https://splits.io/api/v4/runners/:runner/games
curl https://splits.io/api/v4/runners/:runner/categories
```
A Runner is a user who has at least one run tied to their account. Users with zero runs are not discoverable using the
API.

<details>
<summary>Structure of a Runner</summary>

| Field          | Type   | Null? | Description                                                                                                               |
|:---------------|:-------|:------|:--------------------------------------------------------------------------------------------------------------------------|
| `twitch_id`    | string | never | The unique Twitch ID of the user.                                                                                         |
| `name`         | string | never | The Twitch name of the user.                                                                                              |
| `display_name` | string | never | The Twitch display name of the user.                                                                                      |
| `avatar`       | string | never | The Twitch avatar of the user.                                                                                            |
| `created_at`   | string | never | The time and date at which this user first authenticated with Splits.io. This field conforms to [ISO 8601][iso8601].      |
| `updated_at`   | string | never | The time and date at which this user was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
</details>

### Game
```sh
curl https://splits.io/api/v4/games?search=:game
curl https://splits.io/api/v4/games/:game
curl https://splits.io/api/v4/games/:game/categories
curl https://splits.io/api/v4/games/:game/runs
curl https://splits.io/api/v4/games/:game/runners
```
A Game is a collection of information about a game, and a container for Categories. Games are created automatically when
a run is uploaded with an unidentified game name. They try to associate themselves with a Speedrun.com game when
created, but the association is not guaranteed.

<details>
<summary>Structure of a Game</summary>

| Field        | Type                            | Null?          | Description                                                                                                                          |
|:-------------|:--------------------------------|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| `name`       | string                          | never          | The full title of the game, like "Super Mario Sunshine".                                                                             |
| `shortname`  | string                          | when not known | A shortened title of the game, like "sms". Where possible, this name tries to match with those on SpeedRunsLive and/or Speedrun.com. |
| `created_at` | string                          | never          | The time and date at which this game was created on Splits.io. This field conforms to [ISO 8601][iso8601].                           |
| `updated_at` | string                          | never          | The time and date at which this game was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601].            |
| `categories` | array of [Categories][category] | never          | The known speedrun categories for this game.                                                                                         |
</details>

### Category
```sh
curl https://splits.io/api/v4/categories/:category
curl https://splits.io/api/v4/categories/:category/runners
curl https://splits.io/api/v4/categories/:category/runs
```
A Category is a ruleset for a Game (Any%, 100%, MST, etc.) and an optional container for Runs. Each Category necessarily
belongs to a Game. Any number of Categories can be associated with a Game.

<details>
<summary>Structure of a Category</summary>

| Field        | Type   | Null? | Description                                                                                                                   |
|:-------------|:-------|:------|:------------------------------------------------------------------------------------------------------------------------------|
| `id`         | string | never | The unique ID of the category.                                                                                                |
| `name`       | string | never | The name of the category.                                                                                                     |
| `created_at` | string | never | The time and date at which this category was created on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `updated_at` | string | never | The time and date at which this category was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
</details>

### Race, Bingo, Randomizer
```sh
curl https://splits.io/api/v4/races
curl https://splits.io/api/v4/races/:race
curl https://splits.io/api/v4/races/:race/entrant
curl https://splits.io/api/v4/races/:race/chat

curl https://splits.io/api/v4/bingos
curl https://splits.io/api/v4/bingos/:bingo
curl https://splits.io/api/v4/bingos/:bingo/entrant
curl https://splits.io/api/v4/bingos/:bingo/chat

curl https://splits.io/api/v4/randomizers
curl https://splits.io/api/v4/randomizers/:randomizer
curl https://splits.io/api/v4/randomizers/:randomizer/entrant
curl https://splits.io/api/v4/randomizers/:randomizer/chat
```
A Race, Bingo, or Randomizer is a live competition between multiple Runners who share a start time for their run. The
three types are nearly identical except for a few minor field changes described below.

**Note**: For simplicity we'll refer to the trio of Race, Bingo, and Randomizer as "raceables". There is no API type
called raceable; it is a conceptual set of common properties and behaviors.

Nearly all raceable endpoints require user authorization based on the flow described below in the
[Authentication & authorization][authentication] section.

<details>
<summary>Structure of a raceable</summary>

| Field           | Type                                   | Null?                            | Description                                                                                                                   |
|:----------------|:---------------------------------------|:---------------------------------|:------------------------------------------------------------------------------------------------------------------------------|
| `id`            | string                                 | never                            | The unique ID of the raceable.                                                                                                |
| `type`          | string                                 | never                            | The type of raceable: `race`, `bingo`, or `randomizer`. Supplied for convenience.                                             |
| `path`          | string                                 | never                            | A user-friendly URL to the raceable.                                                                                          |
| `visibility`    | number                                 | never                            | The permission set for the raceable. (`0`: public, `1`: invite-only, `2`: secret)                                             |
| `join_token`    | string                                 | always, except creation response | The token needed to join invite only and secret races. This is only non-null in the returned JSON when creating the race.     |
| `notes`         | string                                 | when not provided by creator     | Any notes associatied with the raceable.                                                                                      |
| `started_at`    | string                                 | when the race has not started    | The time and date at which this raceable was started on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `created_at`    | string                                 | never                            | The time and date at which this raceable was created on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `updated_at`    | string                                 | never                            | The time and date at which this raceable was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
| `owner`         | [Runner][runner]                       | never                            | The user who created the raceable.                                                                                            |
| `entrants`      | array of [Entrants][entrant]           | never                            | All entrants currently in the raceable.                                                                                       |
| `chat_messages` | array of [Chat Messages][chat-message] | never                            | Chat messages for the raceable. Only present when fetching the raceable specifically.                                         |

Races have the following extra field:

| Field      | Type                 | Null? | Description               |
|:-----------|:---------------------|:------|:--------------------------|
| `category` | [Category][category] | never | The category being raced. |

Bingos have the following extra fields:

| Field      | Type         | Null?                            | Description                                |
|:-----------|:-------------|:---------------------------------|:-------------------------------------------|
| `game`     | [Game][game] | never                            | The game the bingo is attached to.         |
| `card_url` | string       | when not provided by the creator | The URL that the bingo card is located at. |

Randomizers have the following extra fields:

| Field         | Type                               | Null?                            | Description                                        |
|:--------------|:-----------------------------------|:---------------------------------|:---------------------------------------------------|
| `game`        | [Game][game]                       | never                            | The game the bingo is attached to.                 |
| `seed`        | string                             | when not provided by the creator | The seed name associatied with the randomizer.     |
| `attachments` | array of [Attachments][attachment] | never                            | Any attachments needed to complete the randomizer. |

#### Attachment
Attachments have the following structure:

| Field        | Type   | Can it be null? | Description                                                                                                      |
|:-------------|:-------|:----------------|:-----------------------------------------------------------------------------------------------------------------|
| `id`         | string | never           | The unique ID of the attachment.                                                                                 |
| `created_at` | string | never           | The time and date at which this attachment was created on Splits.io. This field conforms to [ISO 8601][iso8601]. |
| `filename`   | string | never           | The filename of the attachment.                                                                                  |
| `url`        | string | never           | The URL in which to download the attachment.                                                                     |
</details>

<details>
<summary>Fetching active raceables</summary>

```sh
curl https://splits.io/api/v4/races
curl https://splits.io/api/v4/bingos
curl https://splits.io/api/v4/randomizers
```
These endpoints return a list of active raceables of their type. A raceable is active if it
1. is in progress, or
2. has had some activity in the last 30 minutes, or
3. has at least two entrants.
</details>

<details>
<summary>Fetching a single raceable</summary>

```sh
curl https://splits.io/api/v4/races/:race
curl https://splits.io/api/v4/bingos/:bingo
curl https://splits.io/api/v4/randomizers/:randomizer
```
These endpoints get information about a specific raceable. To view information about secret raceables, a `join_token`
parameter must also be provided.

| Status Codes | Success? | Body Present? | Description                                                                             |
|:-------------|:---------|:--------------|:----------------------------------------------------------------------------------------|
| 202          | Yes      | Yes           | Raceable schema will be returned.                                                       |
| 403          | No       | Yes           | This raceable is not viewable by the current user because they lack a valid join token. |
| 404          | No       | Yes           | No raceable found with the provided id.                                                 |
</details>

<details>
<summary>Creating a new raceable</summary>

```sh
curl -X POST https://splits.io/api/v4/races \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"category_id": "40", "notes": "Notes go here"}'
```

```sh
curl -X POST https://splits.io/api/v4/bingos \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"game_id": "40", "card_url": "https://google.com", "visibility": "secret"}'
```

```sh
curl -X POST https://splits.io/api/v4/randomizers \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"game_id": "40", "notes": "Notes go here", "seed": "asdfqweruiop"}'
```
These endpoints open a new raceable. All types can have `notes`, and tier-2+ patrons can use a `visibility` of
`invite_only` or `secret`.

Invite-only raceables can be seen by anyone but only joined with a `join_token`; secret raceables can only be seen or
joined with a `join_token`. The user creating the raceable is given the join token in response to the race creation
call; it is that user's responsibility to share the token with others.

A join token can be shared as a user-friendly link:
```http
https://splits.io/races/:race?join_token=:join_token
https://splits.io/bingos/:bingo?join_token=:join_token
https://splits.io/randomizers/:randomizer?join_token=:join_token
```
The only required parameter between all types is the Game or Category being raced. Attachments cannot be specified at
creation and must take place as a separate action afterwards.

**Note**: Races are associated with a Category, while Bingos and Randomizers are associated with a Game.

| Status Codes | Success? | Body Present? | Description                                                                                                       |
|:-------------|:---------|:--------------|:------------------------------------------------------------------------------------------------------------------|
| 201          | Yes      | Yes           | Successfully created, a raceable schema will be returned.                                                         |
| 400          | No       | Yes           | An error occured while creating the raceable. `error` will contain a human-readable error message.                |
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                                        |
| 403          | No       | Yes           | Cannot create raceable with the desired visibility.                                                               |
</details>

<details>
<summary>Updating a raceable</summary>

```sh
curl -X PATCH https://splits.io/api/v4/races/:race
curl -X PATCH https://splits.io/api/v4/bingos/:bingo
curl -X PATCH https://splits.io/api/v4/randomizers/:randomizer
```
This endpoint can update fields for a raceable. For Bingos this can be used to update the `card_url` parameter. For
Randomizers this is used to add `attachments` to it such as seed files used in the race.

| Status Codes | Success? | Body Present? | Description                                                                                                     |
|:-------------|:---------|:--------------|:----------------------------------------------------------------------------------------------------------------|
| 200          | Yes      | Yes           | Successfully updated. A raceable schema will be returned.                                                       |
| 400          | No       | Yes           | An error occured while saving the raceable. `error` will contain a human-readable error message.                |
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user or the owner of the bingo/randomizer. |
| 403          | No       | Yes           | The raceable has already been started and cannot be updated.                                                    |
| 406          | No       | Yes           | This is only returned when trying to update a regular category race.                                            |

Raceables cannot be deleted. Once one becomes inactive for 30 minutes it will naturally disappear from the listings.
</details>

#### Entrant
```sh
curl           https://splits.io/api/v4/races/:race/entrant
curl -X PUT    https://splits.io/api/v4/races/:race/entrant
curl -X PATCH  https://splits.io/api/v4/races/:race/entrant
curl -X DELETE https://splits.io/api/v4/races/:race/entrant

curl           https://splits.io/api/v4/bingos/:bingo/entrant
curl -X PUT    https://splits.io/api/v4/bingos/:bingo/entrant
curl -X PATCH  https://splits.io/api/v4/bingos/:bingo/entrant
curl -X DELETE https://splits.io/api/v4/bingos/:bingo/entrant

curl           https://splits.io/api/v4/randomizers/:randomizer/entrant
curl -X PUT    https://splits.io/api/v4/randomizers/:randomizer/entrant
curl -X PATCH  https://splits.io/api/v4/randomizers/:randomizer/entrant
curl -X DELETE https://splits.io/api/v4/randomizers/:randomizer/entrant
```
An entrant represents a Runner's participation in a race.

All endpoints in this section require an access token and operate exclusively on the authenticated user's Entrant, if it
exists.

<details>
<summary>Structure of an Entrant</summary>

| Field          | Type             | Null?                              | Description                                                                                                                  |
|:---------------|:-----------------|:-----------------------------------|:-----------------------------------------------------------------------------------------------------------------------------|
| `id`           | string           | never                              | The unique ID of the entrant.                                                                                                |
| `readied_at`   | string           | when the entrant isn't ready       | The time and date at which this entrant readied up in the raceable. This field conforms to [ISO 8601][iso8601].              |
| `finished_at`  | string           | when the entrant has not finished  | The time and date at which this entrant finished this raceable. This field conforms to [ISO 8601][iso8601].                  |
| `forfeited_at` | string           | when the entrant has not forfeited | The time and date at which this entrant forfeited from this raceable. This field conforms to [ISO 8601][iso8601].            |
| `created_at`   | string           | never                              | The time and date at which this entrant was created on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `updated_at`   | string           | never                              | The time and date at which this entrant was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
| `user`         | [Runner][runner] | never                              | The user represented by this Entrant.                                                                                        |
| `run`          | [Run][run]       | when not supplied by the timer     | The Run linked to the current Entrant. It has more detailed info about this runner's run, such as splits and history.        |
</details>

<details>
<summary>Fetching an Entrant</summary>

```sh
curl -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/races/:race/entrant
curl -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/bingos/:bingo/entrant
curl -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/randomizers/:randomizer/entrant
```
Use this endpoint to find out if the authenticated user is entered in a raceable.

| Possible Status Codes | Success? | Body Present? | Description                                                                |
|:----------------------|:---------|:--------------|:---------------------------------------------------------------------------|
| 200                   | Yes      | Yes           | An entrant schema will be returned.                                        |
| 401                   | No       | No            | Access token is either blank, expired, invalid, or not attached to a user. |
| 404                   | No       | Yes           | There is no Entrant for the user associated with the access token.         |
</details>

<details>
<summary>Creating an Entrant</summary>

```sh
curl -X PUT -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/:type/:id/entrant
```
Use this endpoint to join a raceable. If the raceable is invite-only or secret, you must supply a `join_token`.

| Status Codes | Success? | Body Present? | Description                                                                                              |
|:-------------|:---------|:--------------|:---------------------------------------------------------------------------------------------------------|
| 201          | Yes      | Yes           | Successfully created. An Entrant schema will be returned.                                                |
| 400          | No       | Yes           | An error occured while creating the Entrant. The `error` key will contain a user-friendly error message. |
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                               |
| 403          | No       | Yes           | This raceable is not joinable by the current user because they lack a valid join token.                  |
</details>

<details>
<summary>Updating an Entrant</summary>

```sh
curl -X PATCH https://splits.io/api/v4/:type/:id/entrant \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json'
  -d '{"readied_at":"2019-06-17T03:40:48.123Z"'
```
Use this endpoint to update an Entrant. Valid parameters are `readied_at`, `finished_at`, and `forfeited_at`. Valid
values are either an [ISO 8601][iso8601] timestamp (with up to 3 decimal places of precision), the string `"now"`, or
`null` (to undo a ready, forfeit, or finish).

When passing `"now"`, a timestamp will be recorded as soon as possible in the request, but this will be subject to the
travel time from your client to Splits.io. When passing `null`, make sure your JSON encoder is not filtering the key
out.

**Note**: A join token is not required if the user is already entered into the race. If they leave, it must be provided
again to rejoin.

| Status Codes | Success? | Body Present? | Description                                                                                              |
|:-------------|:---------|:--------------|:---------------------------------------------------------------------------------------------------------|
| 200          | Yes      | Yes           | Successfully updated. An entrant schema will be returned.                                                |
| 400          | No       | Yes           | An error occured while updating the Entrant. The `error` key will contain a user-friendly error message. |
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                               |
| 404          | No       | Yes           | No Entrant found for the associated user.                                                                |
</details>

<details>
<summary>Deleting an Entrant</summary>

```sh
curl -X DELETE -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/:type/:id/entrant
```
Use this endpoint to part from a raceable before it starts. A started raceable cannot be left, only finished or
forfeited.

| Status Codes | Success? | Body Present? | Description                                                                                              |
|:-------------|:---------|:--------------|:---------------------------------------------------------------------------------------------------------|
| 205          | Yes      | No            | Successfully deleted.                                                                                    |
| 401          | No       | No            | Access token is either blank, expired, invalid, or not attached to a user.                               |
| 404          | No       | Yes           | No Entrant found for the associated user.                                                                |
| 409          | No       | Yes           | An error occured while deleting the Entrant. The `error` key will contain a user-friendly error message. |
</details>

#### Chat Message
```sh
curl https://splits.io/api/v4/races/:race/chat
curl https://splits.io/api/v4/bingos/:bingo/chat
curl https://splits.io/api/v4/randomizers/:randomizer/chat
```
A Chat Message is a shortform message sent by a user to a raceable. The user does not have to be entered into the
raceable in order to send a Chat Message to it.

<details>
<summary>Structure of a Chat Message</summary>

| Field        | Type             | Null? | Description                                                                                                                  |
|:-------------|:-----------------|:------|:-----------------------------------------------------------------------------------------------------------------------------|
| `body`       | string           | never | The contents of the message.                                                                                                 |
| `entrant`    | boolean          | never | Boolean indicating wether the sender was in the race when the message was sent.                                              |
| `created_at` | string           | never | The time and date at which this message was created on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `updated_at` | string           | never | The time and date at which this message was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
| `user`       | [Runner][runner] | never | The Runner that sent the message.                                                                                            |
</details>

<details>
<summary>Creating a Chat Message</summary>

```sh
curl -X POST https://splits.io/api/v4/races/:race/chat \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"body":"a message body here"}'

curl -X POST https://splits.io/api/v4/bingos/:bingo/chat \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"body":"a message body here"}'

curl -X POST https://splits.io/api/v4/randomizers/:randomizer/chat \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"body":"a message body here"}'
```
This endpoint sends a Chat Message to a raceable. The user and entrant fields will be inferred; only pass in a body
parameter which should contain the message that you wish to post.
</details>

[attachment]: #attachment
[authentication]: #authentication--authorization
[category]: #category
[chat-message]: #chat-message
[entrant]: #entrant
[game]: #game
[iso8601]: https://en.wikipedia.org/wiki/ISO_8601
[raceable]: #race-bingo-randomizer
[run]: #run
[runner]: #runner
[segment]: #segment
[uploading]: #uploading
