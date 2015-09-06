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
A Run maps 1:1 to an uploaded splits file.

## Runner
A Runner is a user who has at least one run tied to their account. Users with zero runs are not discoverable using the
API.

## Game
Most timers allow users to specify a "game" field. A Game is a collection of information about the video game specified
in this field. Games have at least one run and have an associated game on SRL. If a game does not have an associated
game on SRL, it is not a Game.

## Category
Some timers allow users to specify a "category" or similar field. A Category is a collection of information about the
type of run performed, more specific than a Game. Each Category belongs to a Game. The definition of a category does not
hold any ties to SRL. Any number of Categories can be associated with a Game.
