# API v4
The Splits.io API supports retrieving runs, runners, games, and categories, as well as uploading, disowning, and deleting
runs and managing races.

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
<summary>Example 1: My application is an app that runs on the user's device</summary>

If your application runs locally as an app or program on the user's device, you should use OAuth's **authorization code grant
flow**. This means your application will open the Splits.io authorization page in the user's default browser, and if the
user accepts the authorization, Splits.io will give your application a `code` which you should immediately exchange for
an OAuth token using a secure API request.

1. Configure your program to run a small web server on a port of your choosing, and listen for `GET` requests to a path
    of your choosing. In this example, let's say you're listening on port 8000 for requests to `/auth/splitsio`.
2. On your Splits.io [settings page][1], set your `redirect_uri` to something like
    ```http
    http://localhost:8000/auth/splitsio
    ```
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
    back to the application. Have your application strip the `code` URL parameter for the next step.
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
2. When a user wants to grant authorization to your application for their Splits.io account, send them to a URL like
    this:
    ```http
    https://splits.io/oauth/authorize?response_type=code&scope=upload_run&redirect_uri=https://YOUR_WEBSITE/auth/splitsio&client_id=YOUR_CLIENT_ID
    ```
    If the user authorizes your application, they will be redirected to a URL like
    ```http
    https://YOUR_WEBSITE/auth/splitsio?code=YOUR_CODE
    ```
    Have your application strip the `code` URL parameter for the next step.
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

## Pagination
Some responses are paginated. You can tell by inspecting the `Link` header in the response, which will look something
like this for paginated responses:

```http
link: <https://splits.io/api/v4/games/oot/runs?page=1>; rel="first", <https://splits.io/api/v4/games/oot/runs?page=1>; rel="prev", <https://splits.io/api/v4/games/oot/runs?page=91>; rel="last", <https://splits.io/api/v4/games/oot/runs?page=3>; rel="next"
```

`first` refers to the first page, `last` to the last page, `prev` to the page before the one being returned, and `next` to the page after the one being returned. None of these are guaranteed to be present, for example when returning the first
page you shouldn't expect a `prev` or `first` link to be present.

## Resource types
### Run
```sh
curl https://splits.io/api/v4/runs/:run
curl https://splits.io/api/v4/runs/:run?historic=1
```
A Run maps 1:1 to an uploaded splits file. Its canonical ID string is a base 36 number, e.g. `"1b"` `"3nm"` `"1vr"`,
which you should substitite any time you see `:run` in these docs.

<details>
<summary>Structure of a Run</summary>

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/run.json)

| Field                     | Type                         | Null?                                                 | Description                                                                                                                                                                                                                                  |
|:--------------------------|:-----------------------------|:------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`                      | string                       | never                                                 | Unique ID for identifying the run on Splits.io. This can be used to construct a user-facing URL or an API-facing one.                                                                                                                        |
| `srdc_id`                 | string                       | when no associated speedrun.com run                   | Unique ID for identifying the run on Speedrun.com. This is typically supplied by the runner manually.                                                                                                                                        |
| `realtime_duration_ms`    | number                       | never                                                 | Realtime duration in milliseconds of the run.                                                                                                                                                                                                |
| `realtime_sum_of_best_ms` | number                       | never                                                 | Realtime sum of best in milliseconds of the run.                                                                                                                                                                                             |
| `gametime_duration_ms`    | number                       | never                                                 | Gametime duration in milliseconds of the run.                                                                                                                                                                                                |
| `gametime_sum_of_best_ms` | number                       | never                                                 | Gametime sum of best in milliseconds of the run.                                                                                                                                                                                             |
| `default_timing`          | string                       | never                                                 | The timing used for the run.  Will be either `real` or `game`.                                                                                                                                                                               |
| `program`                 | string                       | never                                                 | The name of the timer with which the run was recorded. This is typically an all lowercase, no-spaces version of the program name.                                                                                                            |
| `attempts`                | number                       | when not supported by the source timer                | The number of run attempts recorded by the timer that generated the run's source file.                                                                                                                                                       |
| `image_url`               | string                       | when not supplied by runner                           | A screenshot of the timer after a finished run. This is typically supplied automatically by timers which support auto-uploading runs to Splits.io.                                                                                           |
| `parsed_at`               | string                       | when not yet parsed                                   | The time and date at which this run's source file was finished being parsed by Splits.io. This field conforms to [ISO 8601][iso8601].                                                                                                        |
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
A Segment maps to a single piece of a run, also called a split. Its canonical ID string is a UUID, e.g.
`"c198a25f-9f8a-43cd-92ab-472a952f9336"`, which you should substitite any time you see `:segment` in these docs.

Segment objects have the following format:

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/segment.json)

| Field                           | Type    | Null?          | Description                                                                                                                                                                                                                                                        |
|:--------------------------------|:--------|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`                            | string  | never          | Internal ID of the segment.                                                                                                                                                                                                                                        |
| `name`                          | string  | never          | Name of the segment. This value is an exact copy of timers' fields.                                                                                                                                                                                                |
| `display_name`                  | string  | never          | Name of the segment without any subsplit-related naming tools.                                                                                                                                                                                                     |
| `segment_number`                | number  | never          | The segment number of the run. (This value starts at 0)                                                                                                                                                                                                            |
| `realtime_start_ms`             | number  | never          | The total elapsed time of the run at the moment when this segment was started in realtime. Provided in milliseconds.                                                                                                                                               |
| `realtime_duration_ms`          | number  | never          | Realtime duration in milliseconds of the segment.                                                                                                                                                                                                                  |
| `realtime_end_ms`               | number  | never          | The total elapsed time of the run at the moment when this segment was finished in realtime (such that the run's duration is equal to the final split's finish time). Provided in milliseconds.                                                                     |
| `realtime_shortest_duration_ms` | number  | when not known | The shortest duration the runner has ever gotten on this segment in realtime.  Provided in milliseconds.                                                                                                                                                            |
| `realtime_gold`                 | boolean | never          | Whether or not this split *was* the shortest duration the runner has ever gotten on this segment in realtime. This field is shorthand for `realtime_duration_ms == realtime_shortest_duration_ms`.                                                                 |
| `realtime_skipped`              | boolean | never          | Whether or not this split was skipped in realtime -- some timers let the runner skip over a split in case they forgot to hit their split button on time. Beware that a skipped split's duration is considered `0`, and instead is rolled into the following split. |
| `realtime_reduced`              | boolean | never          | Whether or not this segment was "reduced" in realtime; that is, had its duration affected by previous splits being skipped.                                                                                                                                        |
| `gametime_start_ms`             | number  | never          | The total elapsed time of the run at the moment when this segment was started in gametime. Provided in milliseconds.                                                                                                                                               |
| `gametime_duration_ms`          | number  | never          | Gametime duration in milliseconds of the segment.                                                                                                                                                                                                                  |
| `gametime_end_ms`               | number  | never          | The total elapsed time of the run at the moment when this segment was finished in gametime (such that the run's duration is equal to the final split's finish time). Provided in milliseconds.                                                                     |
| `gametime_shortest_duration_ms` | number  | when not known | The shortest duration the runner has ever gotten on this segment in gametime.  Provided in milliseconds.                                                                                                                                                            |
| `gametime_gold`                 | boolean | never          | Whether or not this split *was* the shortest duration the runner has ever gotten on this segment in gametime. This field is shorthand for `duration == best`.                                                                                                      |
| `gametime_skipped`              | boolean | never          | Whether or not this split was skipped in gametime -- some timers let the runner skip over a split in case they forgot to hit their split button on time. Beware that a skipped split's duration is considered `0`, and instead is rolled into the following split. |
| `gametime_reduced`              | boolean | never          | Whether or not this segment was "reduced" in gametime; that is, had its duration affected by previous splits being skipped.                                                                                                                                        |

If a `historic=1` param is included in the request, one additional field will be present:

|       Field | Type                     | Null? | Description                                                                                                                                                                                                                               |
|------------:|:-------------------------|:------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `histories` | array of History objects | never | Ordered history objects of all previous runs. The first item is the first run recorded by the runner's timer into the source file. The last item is the most recent one. This field is only nonempty if the source timer records history. |

#### History
History objects have the following format.

| Field                  | Type   | Null?          | Description                                                                                |
|:-----------------------|:-------|:---------------|:-------------------------------------------------------------------------------------------|
| `attempt_number`       | number | never          | The corresponding attempt number this attempt was.                                         |
| `realtime_duration_ms` | number | never          | The realtime duration this attempt took in milliseconds.                                   |
| `gametime_duration_ms` | number | never          | The gametime duration this attempt took in milliseconds.                                   |
| `started_at`           | string | when not known | The date and time of when the attempt started. This field conforms to [ISO 8601][iso8601]. |
| `ended_at`             | string | when not known | The date and time of when the attempt ended. This field conforms to [ISO 8601][iso8601].   |
</details>

<details>
<summary>Getting runs in specific formats</summary>
Splits.io can render many different formats other than JSON. To get one, pass an Accept header with the format you want.

| `Accept` Header Passed           | Return Format             | Return `Content-Type`                |
|:---------------------------------|:--------------------------|:-------------------------------------|
| None                             | JSON                      | `application/json`                   |
| `application/json`               | JSON                      | `application/json`                   |
| `application/splitsio`           | Splits.io Exchange Format | `application/splitsio`               |
| `application/wsplit`             | WSplit                    | `application/wsplit`                 |
| `application/time-split-tracker` | Time Split Tracker        | `application/time-split-tracker`     |
| `application/splitterz`          | SplitterZ                 | `application/splitterz`              |
| `application/livesplit`          | LiveSplit                 | `application/livesplit`              |
| `application/urn`                | Urn                       | `application/urn`                    |
| `application/llanfair-gered`     | Llanfair-Gered            | `application/llanfair-gered`         |
| `application/original-timer`     | Original Run File         | One of the following `Content-Type`s |

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
<summary>Splitting</summary>

```sh
# Non-race runs
curl -X POST https://splits.io/api/v4/runs/:run/splits \
  -H 'Content-Type: application/json' \
  -d '{"split": {"realtime_end_ms": 123456, "gametime_end_ms:" 123456}}'

# Race runs
curl -X POST https://splits.io/api/v4/races/:race/entries/:entry/splits?more=1
  -H 'Content-Type: application/json' \
  -d '{"split": {"realtime_end_ms": 123456, "gametime_end_ms:" 123456}}'
```

If you want to split an in-progress run without re-uploading the entire thing (as in *Uploading runs* -> *Replacing
source files* above), you can split using this endpoint.

This is a relatively handsfree endpoint. It will find the first segment without a time recorded, and attach the given
`realtime_end_ms` and/or `gametime_end_ms` to it; each representing the total number of elapsed milliseconds in the
_entire run_ at the time the segment was completed. Other fields like golds, durations, and starts will be calculated
automatically.

If you want to skip a split, just submit `null` for both `realtime_duration_ms` and `gametime_duration_ms`.

If you need more control over your segments than this endpoint provides, you should instead replace the run's source
file entirely (see *Uploading runs* -> *Replacing source files* above).

#### Race runs vs non-race runs
At the top of this section there are two equivalent splitting endpoints listed; one for normal runs and one for race
runs.

A race run is just a [Run][run] which will be completed as part of a [Race][race]. To associate the two, upload the run
as normal and link it with an [Entry][entry] using the [Entry update endpoint][entry].

Do not use the "normal run" splitting endpoint for race runs, as this will cause the race to be unaware of updates as
the user splits.

#### Blind or semi-blind runs
If the runner is doing a run or race where you don't know how many splits there are going to be, just pass `more=1` with
each split. Splits.io will continuously create new segments as you split in a way that displays nicely on the run and
race pages. You can even start splitting without associating a Run with the Entry; a new Run will be created and linked
for you, and the first call to the split endpoint will create and immediately end the first segment.

When splitting like this and you're ready to perform the final split, just split _without_ `more=1`. This will be the
final split. On race runs, this will also mark the user's race Entry as finished. (Alternatively, you can use the
[Entry][entry] API to set `finished_at`, and this will perform the final split in the linked Run.)
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
curl https://splits.io/api/v4/runner # authenticated runner
curl https://splits.io/api/v4/runners/:runner
curl https://splits.io/api/v4/runners/:runner/runs
curl https://splits.io/api/v4/runners/:runner/pbs
curl https://splits.io/api/v4/runners/:runner/games
curl https://splits.io/api/v4/runners/:runner/categories
```
A Runner is a user who has at least one run tied to their account. Its canonical ID string is their Splits.io username
all-lowercased, e.g. `"glacials"`, `"batedurgonnadie"`, `"snarfybobo"`, which you should substitite any time you see
`:runner` in these docs.

Users with zero runs are not discoverable using the API.

<details>
<summary>Structure of a Runner</summary>

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/runner.json)

| Field          | Type   | Null?           | Description                                                                                                               |
|:---------------|:-------|:----------------|:--------------------------------------------------------------------------------------------------------------------------|
| `id`           | string | never           | The unique ID of the user.                                                                                                |
| `twitch_id`    | string | when not linked | The Twitch ID of the user.                                                                                         |
| `twitch_name`  | string | when not linked | The Twitch name of the user.                                                                                       |
| `display_name` | string | never           | The display name of the user.                                                                                      |
| `name`         | string | never           | The Splits.io username of the user.                                                                                       |
| `avatar`       | string | never           | The avatar of the user.                                                                                                   |
| `created_at`   | string | never           | The time and date at which this user first authenticated with Splits.io. This field conforms to [ISO 8601][iso8601].      |
| `updated_at`   | string | never           | The time and date at which this user was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
</details>

### Game
```sh
curl https://splits.io/api/v4/games?search=:game
curl https://splits.io/api/v4/games/:game
curl https://splits.io/api/v4/games/:game/categories
curl https://splits.io/api/v4/games/:game/categories?filter=nonempty # Only return categories with runs
curl https://splits.io/api/v4/games/:game/runs
curl https://splits.io/api/v4/games/:game/runners
```
A Game is a collection of information about a game, and a container for Categories. Its canonical ID string is its
Speedrun.com shortname, e.g. `"sms"`, `"sm64"`, `"portal"`, which you should substitite any time you see `:game` in
these docs.

Games are created automatically when a run is uploaded with an unidentified game name. They try to associate themselves
with a Speedrun.com game when created, but the association is not guaranteed.

When searching for games, it is possible to pass in a game ID. If a game with this ID exists, it will be prepended to
the search response array.

<details>
<summary>Structure of a Game</summary>

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/game.json)

| Field        | Type                            | Null?          | Description                                                                                                                          |
|:-------------|:--------------------------------|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| `id`         | string                          | never          | The unique ID of the game.                                                                                                           |
| `name`       | string                          | never          | The full title of the game, like "Super Mario Sunshine".                                                                             |
| `shortname`  | string                          | when not known | A shortened title of the game, like "sms". Where possible, this name tries to match with those on SpeedRunsLive and/or Speedrun.com. |
| `created_at` | string                          | never          | The time and date at which this game was created on Splits.io. This field conforms to [ISO 8601][iso8601].                           |
| `updated_at` | string                          | never          | The time and date at which this game was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601].            |
| `categories` | array of [Categories][category] | never          | The known speedrun categories for this game.                                                                                         |
| `srdc_id`    | string                          | when not known | The ID this game holds on speedrun.com, if present and known.                                                                        |
| `cover_url`  | string                          | when not known | The URL for this game's box art, if known.                                                                                           |
</details>

### Category
```sh
curl https://splits.io/api/v4/categories/:category
curl https://splits.io/api/v4/categories/:category/runners
curl https://splits.io/api/v4/categories/:category/runs
```
A Category is a ruleset for a Game (Any%, 100%, MST, etc.) and an optional container for Runs. Its canonical ID string
is a base 10 number, e.g. `"312"`, `"1456"`, `"11"`, which you should substitite any time you see `:category` in these
docs.

Each Category necessarily belongs to a Game. Any number of Categories can be associated with a Game.

<details>
<summary>Structure of a Category</summary>

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/category.json)

| Field        | Type   | Null? | Description                                                                                                                   |
|:-------------|:-------|:------|:------------------------------------------------------------------------------------------------------------------------------|
| `id`         | string | never | The unique ID of the category.                                                                                                |
| `name`       | string | never | The name of the category.                                                                                                     |
| `created_at` | string | never | The time and date at which this category was created on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `updated_at` | string | never | The time and date at which this category was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
</details>

### Race
```sh
curl https://splits.io/api/v4/races
curl https://splits.io/api/v4/races?historic=1
curl https://splits.io/api/v4/races/:race
curl https://splits.io/api/v4/races/:race/entries
curl https://splits.io/api/v4/races/:race/chat
```
A Race is a live competition between multiple Runners who share a start time for their run. Its canonical ID string is a
UUID, e.g. `"c198a25f-9f8a-43cd-92ab-472a952f9336"`, which you should substitite any time you see `:race` in these docs.

Nearly all race endpoints require user authorization based on the flow described below in the [Authentication &
authorization][authentication] section.

<details>
<summary>Structure of a Race</summary>

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/race.json)

| Field           | Type                                   | Null?                            | Description                                                                                                               |
|:----------------|:---------------------------------------|:---------------------------------|:--------------------------------------------------------------------------------------------------------------------------|
| `id`            | string                                 | never                            | The unique ID of the Race.                                                                                                |
| `path`          | string                                 | never                            | The user-friendly URL to the Race, to be given to a user when necessary.                                                  |
| `game`          | [Game][game]                           | when not provided by the creator | The game being raced.                                                                                                     |
| `category`      | [Category][category]                   | when not provided by the creator | The category being raced.                                                                                                 |
| `visibility`    | string                                 | never                            | The permission set for the Race. (`"public"`, `"invite_only"`, or `"secret"`)                                             |
| `join_token`    | string                                 | always, except creation response | The token needed to join the race if it's invite-only or secret. Only provided to the owner as a response to creation.    |
| `notes`         | string                                 | when not provided by creator     | Any notes associated with the Race.                                                                                      |
| `owner`         | [Runner][runner]                       | never                            | The Runner who created the Race.                                                                                          |
| `entries`       | array of [Entries][entry]              | never                            | All Entries currently in the Race.                                                                                        |
| `chat_messages` | array of [Chat Messages][chat-message] | never                            | Chat messages for the Race. Only present when fetching the Race individually.                                             |
| `attachments`   | array of [Attachments][attachment]     | never                            | Any attachments supplied by the race creator for the benefit of other entrants (e.g. for randomizers).                    |
| `started_at`    | string                                 | when the race has not started    | The time and date at which this Race was started on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `created_at`    | string                                 | never                            | The time and date at which this Race was created on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `updated_at`    | string                                 | never                            | The time and date at which this Race was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |

#### Attachment
Attachments have the following structure:

| Field        | Type   | Can it be null? | Description                                                                                                      |
|:-------------|:-------|:----------------|:-----------------------------------------------------------------------------------------------------------------|
| `id`         | string | never           | The unique ID of the attachment.                                                                                 |
| `created_at` | string | never           | The time and date at which this attachment was created on Splits.io. This field conforms to [ISO 8601][iso8601]. |
| `filename`   | string | never           | The filename of the attachment.                                                                                  |
| `url`        | string | never           | The URL from which the attachment can be downloaded.                                                             |
</details>

<details>
<summary>Fetching Races</summary>

```sh
curl https://splits.io/api/v4/races
```
This endpoint return a list of active Races of their type. A Race is active if it
1. is in progress, or
2. has had some activity in the last 30 minutes, or
3. has at least two entries.

If you wish to retrieve a listing of previous completed races, pass `historic=1` to the request. This response will be
paginated unlike the active races version.
</details>

<details>
<summary>Fetching a single Race</summary>

```sh
curl https://splits.io/api/v4/races/:race
```
Get information about a Race. To view information about secret Races, a `join_token` parameter must also be
provided.

| Status Codes | Success? | Description                                                                         |
|:-------------|:---------|:------------------------------------------------------------------------------------|
| 202          | Yes      | Race schema will be returned.                                                       |
| 403          | No       | This Race is not viewable by the current user because they lack a valid join token. |
| 404          | No       | No Race found with the provided id.                                                 |
</details>

<details>
<summary>Creating a new Race</summary>

```sh
curl -X POST https://splits.io/api/v4/races \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"race": {"game_id": "123", "category_id": "456", "notes": "Bingo\n\nCome join!", "visibility": "public"}'
```
Create a new Race, specifying any of the fields listed in *Updating a Race* below.

Invite-only Races can be seen by anyone but only joined with a `join_token`; secret Races can only be seen or
joined with a `join_token`. The join token is returned after creation. You can build it into a user-friendly link:
```http
https://splits.io/races/:race?join_token=:join_token
```
This link is effectively the password for the Race. The Race owner can always view this link on the Race's page on
Splits.io.

The only required parameter between all types is the Game or Category being raced. Attachments cannot be specified at
creation and must take place as a separate action afterwards.

| Status Codes | Success? | Description                                                                                    |
|:-------------|:---------|:-----------------------------------------------------------------------------------------------|
| 201          | Yes      | Successfully created, a Race schema will be returned.                                          |
| 400          | No       | An error occured while creating the Race. `error` will contain a human-readable error message. |
| 401          | No       | Access token is either blank, expired, invalid, or not attached to a user.                     |
</details>

<details>
<summary>Updating a Race</summary>

```sh
curl -X PATCH https://splits.io/api/v4/races/:race
```
Update one or more fields of the Race. This endpoint requires that the authenticated user is the creator of the Race.

| Field         | Type   | Required? | Description                                                                             |
|:--------------|:-------|:----------|:----------------------------------------------------------------------------------------|
| `visibility`  | string | yes       | One of `public`, `invite_only`, or `secret`                                             |
| `game_id`     | string | no        | The ID of the game being raced, or `null` if the race spans multiple games.             |
| `category_id` | string | no        | The ID of the category being raced, or `null` if it's not an RTA category (e.g. bingo). |
| `notes`       | string | no        | Longform text displayed on the race page. The first line will be appended to the title. |

| Status Codes | Success? | Description                                                                                         |
|:-------------|:---------|:----------------------------------------------------------------------------------------------------|
| 200          | Yes      | Successfully updated. A Race schema will be returned.                                               |
| 400          | No       | An error occured while saving the Race. `error` will contain a human-readable error message.        |
| 401          | No       | Access token is either blank, expired, invalid, or not attached to a user or the owner of the race. |
| 403          | No       | The Race has already been started and cannot be updated.                                            |

Races can only be updated before they have started.
Races cannot be deleted. Once one becomes inactive for 1 hour it will naturally disappear from the listings.
</details>

#### Entry
```sh
curl           https://splits.io/api/v4/races/:race/entries/:entry
curl -X POST   https://splits.io/api/v4/races/:race/entries
curl -X PATCH  https://splits.io/api/v4/races/:race/entries/:entry
curl -X DELETE https://splits.io/api/v4/races/:race/entries/:entry
```
An Entry represents a Runner's participation in a Race or a ghost of a past Run. Its canonical ID string is a UUID, e.g.
`"61db2b30-e024-45c5-b188-e9986ff1c89c"`, which you should substitite any time you see `:entry` in these docs.

All Entry endpoints require an access token.

<details>
<summary>Structure of an Entry</summary>

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/entry.json)

| Field          | Type             | Null?                            | Description                                                                                                                         |
|:---------------|:-----------------|:---------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|
| `id`           | string           | never                            | The unique ID of the Entry.                                                                                                         |
| `runner`       | [Runner][runner] | never                            | The user represented by this Entry.                                                                                                 |
| `creator`      | [Runner][runner] | never                            | The user that created this Entry; can be different from `runner` if the Entry is a ghost.                                           |
| `run`          | [Run][run]       | when not supplied by the timer   | The Run linked to the current Entry. It has more detailed info about this runner's run, such as splits and history.                 |
| `ghost`        | boolean          | never                            | Whether the Entry represents a past recording of a run (`true`) or a real user that has entered into the race explicitly (`false`). |
| `readied_at`   | string           | when the Entry isn't ready       | The time and date at which this Entry readied up in the Race. This field conforms to [ISO 8601][iso8601].                           |
| `finished_at`  | string           | when the Entry has not finished  | The time and date at which this Entry finished this Race. This field conforms to [ISO 8601][iso8601].                               |
| `forfeited_at` | string           | when the Entry has not forfeited | The time and date at which this Entry forfeited from this Race. This field conforms to [ISO 8601][iso8601].                         |
| `created_at`   | string           | never                            | The time and date at which this Entry was created on Splits.io. This field conforms to [ISO 8601][iso8601].                         |
| `updated_at`   | string           | never                            | The time and date at which this Entry was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601].          |
</details>

<details>
<summary>Fetching an Entry</summary>

```sh
curl -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/races/:race/entries/:entry
```
Get information about an Entry in a Race.

| Possible Status Codes | Success? | Description                                                                |
|:----------------------|:---------|:---------------------------------------------------------------------------|
| 200                   | Yes      | The Entry exists; returns an [Entry][entry].                               |
| 401                   | No       | Access token is either blank, expired, invalid, or not attached to a user. |
| 404                   | No       | The Entry for the given Race does not exist.                               |
</details>

<details>
<summary>Creating an Entry</summary>

```sh
curl -X POST https://splits.io/api/v4/races/:race/entries \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
```
Join a Race. There are no required arguments, however you can supply any parameters specified below in *Updating an
Entry*, e.g.
```json
{"entry": {"run_id": "gcb"}}
```

To make a ghost entry, simply supply a `run_id` of a Run on Splits.io that has already completed. The Entry will
automatically become a ghost, inheriting the Run's time, splits, and runner. The authenticated user will be assigned as
the Entry's `creator`.

If the Race is invite-only or secret, you must supply a `join_token`. The `join_token` should be at the top-level, not
within an `entry` object.

| Status Codes | Success? | Description                                                                                            |
|:-------------|:---------|:-------------------------------------------------------------------------------------------------------|
| 201          | Yes      | Successfully created; returns an [Entry][entry].                                                       |
| 400          | No       | An error occured while creating the Entry. The `error` key will contain a user-friendly error message. |
| 401          | No       | Access token is either blank, expired, invalid, or not attached to a user.                             |
| 403          | No       | This Race is not joinable by the current user because they lack a valid join token.                    |
</details>

<details>
<summary>Updating an Entry</summary>

```sh
curl -X PATCH https://splits.io/api/v4/races/:race/entries/:entry \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{"entry": {"readied_at": "2019-06-17T03:40:48.123Z"}}'
```
Change an Entry. Valid parameters are `readied_at`, `finished_at`, `forfeited_at`, and `run_id`.

| Field          | Type                       | Null?                            | Description                                                                                                         |
|:---------------|:---------------------------|:---------------------------------|:--------------------------------------------------------------------------------------------------------------------|
| `run_id`       | string                     | when not set by you              | The [Run][run] ID corresponding to the splits for this Race. See: [replacing source files][replacing-source-files]. |
| `readied_at`   | [ISO 8601][iso8601] string | when the runner isn't ready      | The timestamp when this runner readied up, if at all.                                                               |
| `finished_at`  | [ISO 8601][iso8601] string | when the runner hasn't finished  | The timestamp when this runner finished the Race, if at all.                                                        |
| `forfeited_at` | [ISO 8601][iso8601] string | when the runner hasn't forfeited | The timestamp when this runner forfeited the Race, if at all.                                                       |

An attached `entry.run_id` (optional) will associate the given Run with the Entry in order to display splits. The run
should not be a completed run when you attach it. You can [continuously update the Run][replacing-source-files] as the
user splits to keep the race page up-to-date for stats and comparison purposes.

The timestamps support three decimal places of precision. They serve as pseudo-booleans; they are the source of truth
for whether a runner is ready/finished/forfeited (`null` for no; non-`null` for yes).

You may optionally set these by passing the string `"now"`; this is a special string which will make the backend use the
current time. The travel time from you to Splits.io will affect the timestamp, so we don't recommend doing this for
`finished_at` where accuracy is important.

To unset one of these fields (e.g. to unready the runner), simply set it to `null`. Make sure your JSON encoder does not
filter the key out, as this is different from not passing the key at all.

| Status Codes | Success? | Description                                                                                            |
|:-------------|:---------|:-------------------------------------------------------------------------------------------------------|
| 200          | Yes      | Successfully updated. An Entry schema will be returned.                                                |
| 400          | No       | An error occured while updating the Entry. The `error` key will contain a user-friendly error message. |
| 401          | No       | Access token is either blank, expired, invalid, or not attached to a user.                             |
| 403          | No       | Access token is valid but its user does not have access to this Entry.                                 |
| 404          | No       | No Race found or Entry found for the associated user.                                                  |
</details>

<details>
<summary>Deleting an Entry</summary>

```sh
curl -X DELETE -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' https://splits.io/api/v4/races/:race/entries/:entry
```
Leave a Race. A Race that has already started cannot be left, only finished or forfeited.

| Status Codes | Success? | Description                                                                                            |
|:-------------|:---------|:-------------------------------------------------------------------------------------------------------|
| 200          | Yes      | Successfully deleted.                                                                                  |
| 401          | No       | Access token is either blank, expired, invalid, or not attached to a user.                             |
| 403          | No       | Access token is valid but its user does not have access to this Entry.                                 |
| 404          | No       | No Race found or Entry found for the associated user.                                                  |
| 409          | No       | An error occured while deleting the Entry. The `error` key will contain a user-friendly error message. |
</details>

#### Chat Message
```sh
curl https://splits.io/api/v4/races/:race/chat
```
A Chat Message is a shortform message sent by a user to a Race. The user does not have to be entered into the Race in
order to send a Chat Message to it.

<details>
<summary>Structure of a Chat Message</summary>

[Autogenerated JSON Schema documentation](http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/spec/support/models/api/v4/chat_message.json)

| Field          | Type             | Null? | Description                                                                                                                  |
|:---------------|:-----------------|:------|:-----------------------------------------------------------------------------------------------------------------------------|
| `body`         | string           | never | The contents of the message.                                                                                                 |
| `from_entrant` | boolean          | never | Boolean indicating whether the sender was in the race when the message was sent.                                              |
| `created_at`   | string           | never | The time and date at which this message was created on Splits.io. This field conforms to [ISO 8601][iso8601].                |
| `updated_at`   | string           | never | The time and date at which this message was most recently modified on Splits.io. This field conforms to [ISO 8601][iso8601]. |
| `user`         | [Runner][runner] | never | The Runner that sent the message.                                                                                            |
</details>

<details>
<summary>Fetching chat for a race</summary>

```sh
curl https://splits.io/api/v4/races/:race/chat
```

| Status Codes | Success? | Description                                                |
|:-------------|:---------|:-----------------------------------------------------------|
| 200          | Yes      | A paginated array of all the chat messages for the Race.   |
| 403          | No       | User does not have permission to read chat from this Race. |
| 404          | No       | No Race found for the ID given.                            |

</details>

<details>
<summary>Creating a Chat Message</summary>

```sh
curl -X POST https://splits.io/api/v4/races/:race/chat \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"chat_message": {"body": "a message body here"}}'
```
Send a Chat Message to a Race. All fields except `body` are inferred from your access token.

| Status Codes | Success? | Description                                                                                              |
|:-------------|:---------|:---------------------------------------------------------------------------------------------------------|
| 201          | Yes      | Successfully created; returns a [Chat Message][chat-message]                                             |
| 400          | No       | An error occured while creating the message. The `error` key will contain a user-friendly error message. |
| 403          | No       | User does not have permission to send chat to this Race.                                                 |
| 404          | No       | No Race found for the ID given.                                                                          |

</details>

### WebSockets
Splits.io broadcasts updates to [Races][race] in realtime over WebSockets. We use WebSockets only to push
changes from Splits.io to clients; to send data the other way, you must use the REST APIs above.

<details>
<summary>Why can't I use WebSockets to write data?</summary>

To use WebSockets bidirectionally, clients need to do a lot of legwork. They have to nonce request messages to tell
responses apart. They need to wait indefinitely for a response to every message they send. They have to handle the
possibilities that a sent response might not arrive; that a delivered request might not be processed; that a response
can error because of them, or because of the server; that they get rate limited; that their authentication expires; that
a user expects to see any issues in the console; and many more.

**All** these needs are solved by HTTP. It's free. It doesn't sound like much, but trust us -- we built Races to be
handled 100% over WebSockets, and got so many headaches re-implementing what were effectively basic features of HTTP or
REST that we switched the nearly-complete implementation to the read-only WebSockets version you see today.

As for the advantages of a persistent connection, [HTTP/2][1] solves this problem transparently! It keeps the TCP socket
between client and server open during multiple requests. (Yes, we support HTTP/2!)

[1]: https://en.wikipedia.org/wiki/HTTP/2
</details>

We use a light layer on top of WebSockets called Action Cable. This layer is so light that you can use vanilla
WebSockets without noticing it's there; but if you happen to be using JavaScript, you might opt to use the [Action Cable
JavaScript library][actioncable-npm] to simplify your code a bit.

In all examples below, we'll provide instructions for consuming Splits.io WebSockets using vanilla JavaScript as well as
the Action Cable library. The vanilla JS instructions can roughly translate to whatever language you're using.

**Note**: To assist languages that use strongly-typed schemas, Splits.io WebSocket fields that can hold one of multiple
object types are double-encoded (its value is a string containing more JSON). What you might expect to look like
```json
{
  "type": "confirm_subscription",
  "identifier": {"channel": "Api::V4::GlobalRaceChannel"},
}
```
might instead look like
```json
{
  "type": "confirm_subscription",
  "identifier": "{\"channel\":\"Api::V4::GlobalRaceChannel\"}",
}
```
If you're not using a language with strongly-typed schemas, just decode the embedded JSON again.

[actioncable-npm]: https://www.npmjs.com/package/actioncable

#### Connecting

<details>
<summary>Connecting with vanilla JavaScript</summary>

```javascript
const websocket = new WebSocket("wss://splits.io/api/cable")
// Splits.io's reply: {"type": "welcome"}

websocket.onmessage = function(event) {
  const msg = JSON.parse(event.data)
  switch(msg.type) {
    case 'welcome':
      console.log('Connected!')
      break;
    case 'ping':
      // ...
      break;
  }
}
```
Connecting is as easy as opening the socket and listening for messages.

**Note**: Supply an `access_token` field in the URL to access the authenticated user's secret races.

Once connected you'll receive a timestamped ping every ~3 seconds:
```json
{
  "type": "ping",
  "message": 1561095929
}
```
You do not need to reply to pings. However if you don't get one for an extended period of time you should assume network
conditions have killed your connection, and attempt to re-establish it.
</details>

<details>
<summary>Connecting with Action Cable</summary>

```javascript
import actioncable from "@rails/actioncable"

const cable = actioncable.createConsumer("wss://splits.io/api/cable")
```
This initiates the socket; it will be lazily connected in the next step.
</details>

</details>

#### Subscribing to channels
To receive updates from Splits.io, you first have to tell it what you want updates about. You do this by subscribing to
**channels**.

There are two channel types:

| Channel           | Required params | Optional params       | Description                            |
|:------------------|:----------------|:----------------------|:---------------------------------------|
| GlobalRaceChannel | *none*          | `state`               | high-level information about all Races |
| RaceChannel       | `race_id`       | `state`, `join_token` | detailed information about one Race    |

There is one GlobalRaceChannel and `n` RaceChannels (one for each Race). You can be subscribed to any number of channels
at once, and they all stream over the same WebSocket connection.

If you pass `state=1` when subscribing, you will get a dump of the current state of the world for that channel. You can
use this to e.g. populate UIs when they first load.

<details>
<summary>Subscribing to a channel with vanilla JavaScript</summary>

```javascript
websocket.send(JSON.stringify({
  command: 'subscribe',
  identifier: JSON.stringify({
    channel: 'Api::V4::GlobalRaceChannel'
  })
}))

/* Splits.io's reply:
{
  "type": "confirm_subscription",
  "identifier": "{
    \"channel\": \"Api::V4::GlobalRaceChannel\"
  }"
}
*/
```

```javascript
websocket.send(JSON.stringify({
  command: 'subscribe',
  identifier: JSON.stringify({
    channel:    "Api::V4::RaceChannel",
    race_id:    "11902182-aead-44c6-a7b8-e526951564b1",
    join_token: "hzT5Fp6tX96wt2omLmRn4RHT"
  })
}))

/* Splits.io's reply:
{
  "type": "confirm_subscription",
  "identifier": "{
    \"channel\":    \"Api::V4::RaceChannel\",
    \"race_id\":    \"11902182-aead-44c6-a7b8-e526951564b1\",
    \"join_token\": \"hzT5Fp6tX96wt2omLmRn4RHT\"
  }",
}
*/
```
</details>

<details>
<summary>Subscribing to a channel with Action Cable</summary>

```javascript
cable.subscriptions.create("Api::V4::GlobalRaceChannel", {
  connection() {
    // Called when the subscription is ready
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    switch(data.type) {
      // See below for GlobalRaceChannel message types
      case '...':
        // ...
        break;
    }
  }
})

cable.subscriptions.create(
  {
    channel: "Api::V4::RaceChannel",
    race_id: "c198a25f-9f8a-43cd-92ab-472a952f9336",
  },
  {
    connected: () => {
      // Called when the subscription is ready
    },

    disconnected: () => {
      // Called when the subscription has been terminated by the server
    },

    received: data => {
      switch(data.type) {
        // See below for RaceChannel message types
        case '...':
          // ...
          break
      }
    }
  }
)
```
</details>

<details>
<summary>Message content & types</summary>

`identifier` is the exact string you received when initiating the subscription, so you can compare it directly to
determine how the message needs to be handled.

`message` is an object that contains the changes Splits.io is notifying you about. Note that the `message` object does
not require extra deserialization.
```json
{
  "identifier": "...",
  "message": {
    "type": "string identifier",
    "data": {
      "message": "human-readable description of what changed",
      ...
    }
  }
}
```

`data` contains fields specific to the type of message (`message.type`):

| Message type                | Applicable channels | Description                                                   | Extra Fields                   |
|:----------------------------|:--------------------|:--------------------------------------------------------------|:-------------------------------|
| `"race_created"`            | GlobalRaceChannel   | A new Race was created                                        | [`race`][race]                 |
| `"global_state"`            | GlobalRaceChannel   | State of the world (in response to `state=1`)                 | [`races`][race]                |
| `"race_updated"`            | RaceChannel         | A property of the race has changed                            | [`race`][race]                 |
| `"new_message"`             | RaceChannel         | A chat message was sent to the Race                           | [`chat_message`][chat-message] |
| `"new_attachment"`          | RaceChannel         | An attachment was added to the Race                           | [`race`][race]                 |
| `"race_state"`              | RaceChannel         | State of the Race (in response to `state=1`)                  | [`race`][race]                 |
| `"race_not_found"`          | RaceChannel         | No Race found for the given ID                                | *none*                         |
| `"race_invalid_join_token"` | RaceChannel         | The join token is not valid for the Race                      | *none*                         |
| `"race_start_scheduled"`    | both                | The/a Race is starting in a few seconds                       | [`race`][race]                 |
| `"race_ended"`              | both                | The/a Race has finished                                       | [`race`][race]                 |
| `"race_entries_updated" `   | both                | An entry was created, changed, or deleted                     | [`race`][race]                 |
| `"fatal_error"`             | both                | An error occured when processing the message                  | *none*                         |
| `"connection_error"`        | both                | Received when connecting to cable with an invalid oauth token | *none*                         |
</details>

[attachment]: #attachment
[authentication]: #authentication--authorization
[category]: #category
[chat-message]: #chat-message
[entry]: #entry
[game]: #game
[iso8601]: https://en.wikipedia.org/wiki/ISO_8601
[race]: #race
[replacing-source-files]: #replacing-source-files
[run]: #run
[runner]: #runner
[segment]: #segment
[uploading]: #uploading
