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
```
A Run maps 1:1 to an uploaded splits file.

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
