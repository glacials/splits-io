# splits i/o API
These docs are for the v3 API.

## Jump to section

### [Game Endpoints][game-endpoints]
### [User Endpoints][user-endpoints]
### [Run Endpoints][run-endpoints]
### [Uploading Runs on Behalf of a User][authorization]

[game-endpoints]: #game-endpoints-1
[user-endpoints]: #user-endpoints-1
[run-endpoints]: #run-endpoints-1
[authorization]: #uploading-runs-on-behalf-of-a-user-1

## Pagination
Routes that return array resources are paginated to 20 items per page. To get a specific page of results, add `?page=N`
to your API hit. The default page is page 1. You'll find pagination info in the HTTP headers of every paginated response
under the `Link`, `Total`, and `Per-Page` fields.

## Overview of routes
Base URL is **https://splits.io/api/v3**.

### Game Endpoints Overview
Game ids are SRL shortnames (e.g. `sms`, `oot`, etc.) or Splits I/O base 10 `id`s (which you can discover in other
routes).

```http
GET /games?search=:term
GET /games/:id
GET /games/:game_id/runs
GET /games/:game_id/categories/:id
GET /games/:game_id/categories/:category_id/runs
```

### User Endpoints Overview
User ids are Twitch usernames or Splits I/O base 10 `id`s.

```http
GET /users/:id
GET /users/:user_id/runs
GET /users/:user_id/pbs
GET /users/:user_id/games/:game_id/categories/:category_id/runs
GET /users/:user_id/games/:game_id/categories/:category_id/pb
GET /users/:user_id/games/:game_id/categories/:category_id/prediction
```

### Run Endpoints Overview
Run ids are Splits I/O base 36 ids. These are the strings you see in user-friendly run URLs like `splits.io/36s`.

```http
GET /runs/:id
DELETE /runs/:id
POST /runs
```

## Route details

### Game Endpoints
Game ids are SRL shortnames (e.g. `sms`, `oot`, etc.) or Splits I/O base 10 `id`s (which you can discover in other
routes).

#### `GET /games?search=:term`
Returns games with names matching `.*:term.*` or shortnames exactly equaling `:term` (in no guaranteed order).

##### Example request
```bash
curl https://splits.io/api/v3/games?search=sonic
```

##### Example response
*(see the `/games/:id` endpoint for the game format)*
```json
{
  "games": [
  {
    "id": 969,
      "name": "Sonic 2006",
      "shortname": null,
      ...
  },
  {
    "id": 172,
    "name": "Sonic Adventure 2 Battle",
    "shortname": "sa2b",
    ...
  },
  ...
  {
    "id": 752,
    "name": "Sonic Unleashed (360/PS3)",
    "shortname": "su360",
    ...
  }
  ]
}
```

#### `GET /games/:id`
Returns information about a game.

##### Example request
```bash
curl https://splits.io/api/v3/games/sms
```
##### Example response
*(see the `/games/:game_id/categories/:id` endpoint for the category format)*
```json
{
  "game": {
    "id": 15,
    "name": "Super Mario Sunshine",
    "shortname": "sms",
    "created_at": "2014-04-18T06:28:59.764Z",
    "updated_at": "2015-02-01T21:33:44.460Z",
    "categories": [ ... ]
  }
}
```
#### `GET /games/:game_id/runs`
Returns all runs for a game. This route is [paginated](#pagination).

##### Example request
```bash
curl https://splits.io/api/v3/games/sms/runs
```

##### Example response
*(see the `/runs/:id` endpoint for the run format)*
```json
{
  "runs": [ ... ]
}
```

#### `GET /games/:game_id/categories/:id`
Returns information about a category.

##### Example request
```bash
curl https://splits.io/api/v3/games/sms/categories/852
```

##### Example response
```json
{
  "category": {
    "id": 852,
    "name": "Any%",
    "created_at": "2015-01-08T02:53:19.867Z",
    "updated_at": "2015-02-01T21:33:44.440Z"
}
```

#### `GET /games/:game_id/categories/:category_id/runs`
Returns all runs for a category. This route is [paginated](#pagination).

##### Example request
```bash
curl https://splits.io/api/v3/games/sms/categories/70/runs
```

##### Example response
*(see the `/runs/:id` endpoint for the run format)*
```json
{
  "runs": [ ... ]
}
```

### User Endpoints
User ids are Twitch usernames (which we call `name`) or Splits I/O base 10 `id`s.

#### `GET /users/:id`
Returns information about a user.

##### Example request
```bash
curl https://splits.io/api/v3/users/glacials
```

##### Example response
```json
{
  "user": {
    "id": 1,
    "twitch_id": 29798286,
    "name": "glacials",
    "avatar": "https://static-cdn.jtvnw.net/jtv_user_pictures/glacials-profile_image-dc04543f973cfddc-300x300.png",
    "created_at": "2014-03-09T19:00:43.640Z",
    "updated_at": "2015-02-01T18:53:03.397Z"
  }
}
```

#### `GET /users/:user_id/runs`
Returns all of a user's runs. This route is [paginated](#pagination).

##### Example request
```bash
curl https://splits.io/api/v3/users/glacials/runs
```

##### Example response
*(see the `/runs/:id` endpoint for the run format)*
```json
{
  "runs": [ ... ]
}
```

#### `GET /users/:user_id/pbs`
Returns all of a user's PBs (one per category). Because of an unnoticed mistake and my desire to not change this endpoint without bumping version, this route is **not** paginated. You can expect it to be in v4, but v3 will remain unpaginated.

##### Example request
```bash
curl https://splits.io/api/v3/users/glacials/pbs
```

##### Example response
*(see the `/runs/:id` endpoint for the run format)*
```json
{
  "pbs": [ ... ]
}
```
#### `GET /users/:user_id/games/:game_id/categories/:category_id/runs`
Returns all of a user's runs for a game/category. This route is [paginated](#pagination).

##### Example request
```bash
curl https://splits.io/api/v3/users/glacials/games/sms/categories/852/runs
```

##### Example response
*(see the `/runs/:id` endpoint for the run format)*
```json
{
  "runs": [ ... ]
}
```

#### `GET /users/:user_id/games/:game_id/categories/:category_id/pb`
Returns a user's PB for a game/category.

##### Example request
```bash
curl https://splits.io/api/v3/users/glacials/games/sms/categories/852/pb
```

##### Example response
*(see the `/runs/:id` for this format)*
```json
{
  "run": { ...  }
}
```

#### `GET /users/:user_id/games/:game_id/categories/:category_id/prediction`
Returns a prediction of this user's next run of this category. Predictions use per-split smoothed moving averages for
all recorded run history of the user for this category. The response for this endpoint looks like a response to a
normal "get run" endpoint, but has a `null` id.

### Run Endpoints
Run ids are Splits I/O base 36 ids. These are the strings you see in user-friendly run URLs like `splits.io/36s`.

#### `GET /runs/:id`
Returns a run.

##### Example request
```bash
curl https://splits.io/api/v3/runs/c6
```

##### Example response
```json
{
  "run": {
    "id": 438,
    "path": "/c6",
    "name": "Sonic Colors",
    "program": "wsplit",
    "image_url": null,
    "created_at": "2014-03-09T19:07:46.483Z",
    "updated_at": "2016-01-27T15:42:02.834Z",
    "video_url": null,
    "splits": [
      {
        "name": "Rotatatron",
        "duration": 501.7,
        "finish_time": 501.7,
        "best": {
          "duration": 462.85
        },
        "history": null,
        "gold": false,
        "skipped": false,
        "reduced": false
      },
      ...
      {
        "name": "Epilogue",
        "duration": 44.719999999999345,
        "finish_time": 5083.74,
        "best": {
          "duration": 44.7199999999993
        },
        "history": null,
        "gold": true,
        "skipped": false,
        "reduced": false
      }
    ],
    "attempts": 9,
    "sum_of_best": 5009.42,
    "user": { ... }
    "game": { ... }
    "category": { ... },
    "time": 5083.74
  }
}
```

#### `DELETE /runs/:id`
Deletes this run (requires authentication).

#### `POST /runs`
Upload a new run. If you want to allow an account to claim ownership of this run, you should inspect the response for a
`uris.claim_uri` and send the user who should own the run there. If they're logged in, their account will automatically
claim ownership of the run, then they'll be immediately redirected to the `uris.public_uri`.

##### Example request
```bash
curl -iX POST --form file=@/path/to/splits_file.lss https://splits.io/api/v3/runs
```

##### Example response
```json
{
  "status": 201,
  "message": "Run created.",
  "uris": {
    "api_uri": "https://splits.io/api/v3/runs/36y",
    "public_uri": "https://splits.io/36y",
    "claim_uri": "https://splits.io/36y?claim_token=03a1adb08ec85d5b00374a70"
  }
}
```

## Uploading Runs on Behalf of a User
If you want to upload runs for a user (e.g. from within a timer), you have two options.

### Simple option
Upload the run without auth and direct the user to the URL in the response body's `uris.claim_uri`. If they are logged
in when they visit it, their account will automatically claim the run.

This is the easier method to implement, but has some flaws:

- The user must open the run in their web browser. If you prefer to upload runs in the background, this method isn't for
  you.
- If there are network or browser issues when the user's browser tries to load the run, it won't be claimed.
- If the user isn't logged in when their browser opens, the run will remain unclaimed. Neither your application nor the
  user will receive any indication of this.

### Advanced option
The advanced option is a standard OAuth2 flow. You can request permission from the user to upload runs to their account
on their behalf. If they accept, you will receive an OAuth token which you can include in your run upload requests in
order to create the run as that user.

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
    The access token expires after the duration specified in `expires_in` (measured in seconds). After it expires, you
    can retrieve a new one with no user intervention using the returned `refresh_token`:
    ```http
    POST https://splits.io/oauth/token
    ```
    ```http
    grant_type=refresh_token
    refresh_token=YOUR_REFRESH_TOKEN
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
    ```
    This will return a new access token (and a new refresh token -- update yours!) in a body format identical to
    original grant (above).

    This style of expiring access tokens periodically and using refresh tokens to replace them improves security by
    making it obvious when a user's stolen credentials are in use. See [RFC 6749][rfc6749-6] for more information on
    refresh tokens.

[1]: https://splits.io/settings
[rfc6749-6]: https://tools.ietf.org/html/rfc6749#section-6

