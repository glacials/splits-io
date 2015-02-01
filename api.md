# splits i/o API

## Pagination
Routes that return array resources are paginated to 20 items per page. To get a specific page of results, add `?page=N`
to your API hit. The default page is page 1. You'll find pagination info in the headers of every paginated response
under the `Link`, `Total`, and `Per-Page` fields.

## Overview of routes
Base URL is **https://splits.io/api/v3**.

### Game-scoped
Game ids are SRL shortnames (e.g. `sms`, `oot`, etc.) or splits-io base 10 `id`s (which you can discover in other
routes).

    GET /games/:id
    GET /games/:game_id/runs
    GET /games/:game_id/categories/:id
    GET /games/:game_id/categories/:category_id/runs

### User-scoped
User ids are Twitch usernames or splits-io base 10 `id`s.

    GET /users/:id
    GET /users/:user_id/runs
    GET /users/:user_id/pbs
    GET /users/:user_id/games/:game_id/categories/:category_id/runs
    GET /users/:user_id/games/:game_id/categories/:category_id/pb
    GET /users/:user_id/games/:game_id/categories/:category_id/prediction

### Run-scoped
Run ids are splits-io base 36 ids. These are the strings you see in user-friendly run URLs like `splits.io/36s`.

    GET /runs/:id
    DELETE /runs/:id
    POST /runs

## Route details

### Game-scoped
Game ids are SRL shortnames (e.g. `sms`, `oot`, etc.) or splits-io base 10 `id`s (which you can discover in other
routes).

#### GET /games/:id
Returns information about this game.

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
    "srl_id": 7,
    "created_at": "2014-04-18T06:28:59.764Z",
    "updated_at": "2015-02-01T21:33:44.460Z",
    "categories": [ ... ]
  }
}
```
#### GET /games/:game_id/runs
Returns all runs for this game. This route is [paginated](#pagination).

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

#### GET /games/:game_id/categories/:id
Returns information about this category.

##### Example request
```bash
curl https://splits.io/api/v3/categories/852
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

#### GET /games/:game_id/categories/:category_id/runs
Returns all runs for this category. This route is [paginated](#pagination).

### User-scoped
User ids are Twitch usernames (which we call `name`) or splits-io base 10 `id`s.

#### GET /users/:id
Returns information about this user.

##### Example request
curl https://splits.io/api/v3/users/glacials

##### Example response
{
  "user": {
    "id": 1,
    "twitch_id": 29798286,
    "name": "glacials",
    "avatar": "http://static-cdn.jtvnw.net/jtv_user_pictures/glacials-profile_image-dc04543f973cfddc-300x300.png",
    "created_at": "2014-03-09T19:00:43.640Z",
    "updated_at": "2015-02-01T18:53:03.397Z"
  }
}

#### GET /users/:user_id/runs
Returns all of this user's runs. This route is [paginated](#pagination).

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

#### GET /users/:user_id/pbs
Returns all of this user's PBs (one per category). This route is [paginated](#pagination).

##### Example request
curl https://splits.io/api/v3/users/glacials/pbs

##### Example response
*(see the `/runs/:id` endpoint for the run format)*
```json
{
  "pbs": [ ... ]
}
```
#### GET /users/:user_id/games/:game_id/categories/:category_id/runs
Returns all of this user's runs for this category. This route is [paginated](#pagination).

##### Example request
curl https://splits.io/api/v3/users/glacials/games/sms/categories/852/runs

##### Example response
*(see the `/runs/:id` endpoint for the run format)*
```json
{
  "runs": [ ... ]
}
```

#### GET /users/:user_id/games/:game_id/categories/:category_id/pb
Returns this user's PB for this category.

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

#### GET /users/:user_id/games/:game_id/categories/:category_id/prediction
Returns a prediction of this user's next run of this category. Predictions use per-split smoothed moving averages for
on all recorded run history of the user for this category. The response for this endpoint looks like a response to a
normal "get run" endpoint, but has a `null` id.

### Run-scoped
Run ids are splits-io base 36 ids. These are the strings you see in user-friendly run URLs like `splits.io/36s`.

#### GET /runs/:id
Returns this run.

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
      "updated_at": "2015-01-31T10:09:02.168Z",
      "user": {
        "id": 1,
        "twitch_id": 29798286,
        "name": "glacials",
        "avatar": "http://static-cdn.jtvnw.net/jtv_user_pictures/glacials-profile_image-dc04543f973cfddc-300x300.png",
        "created_at": "2014-03-09T19:00:43.640Z",
        "updated_at": "2015-02-01T18:53:03.397Z"
      },
      "game": null,
      "category": {
        "id": 3165,
        "name": null,
        "created_at": "2015-01-31T10:09:02.112Z",
        "updated_at": "2015-01-31T10:09:02.195Z"
      },
      "time": 5083.74,
      "splits": [
      {
        "name": "Rotatatron",
        "duration": 501.7,
        "finish_time": 501.7,
        "best": {
          "duration": 462.85
        },
        "gold?": false,
        "skipped?": false
      },
      ...
      {
        "name": "Epilogue",
        "duration": 44.719999999999345,
        "finish_time": 5083.74,
        "best": {
          "duration": 44.7199999999993
        },
        "gold?": true,
        "skipped?": false
      }
    ]
  }
}
```

#### DELETE /runs/:id
Deletes this run (requires authentication).

#### POST /runs
Upload a new run. If you want to allow an account to claim ownership this run, you should inspect the response for a
`uris.claim_uri` and send the user who should own the run there. If they're logged in, their account will automatically
claim ownership of the run and they'll be redirected to the standard run page URI.

##### Example request
```bash
curl -iX POST --form file=@/path/to/splits_file.lss splits.io/api/v2/runs
```

##### Example response
```json
{
  "status": 201,
  "message": "Run created.",
  "uris": {
    "api_uri": "http://localhost:3000/api/v3/runs/36y",
    "public_uri": "http://localhost:3000/36y",
    "claim_uri": "http://localhost:3000/36y?claim_token=03a1adb08ec85d5b00374a70"
  }
}
```
