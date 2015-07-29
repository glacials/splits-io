# API v4

## IDs
Resources are identifyable *only* by the following attributes:

| Collection | Key attribute | Description of key attribute | Examples of key attribute             |
|:-----------|:--------------|:-----------------------------|:--------------------------------------|
| Runners    | Name          | A Twitch username            | glacials, batedurgonnadie, snarfybobo |
| Games      | Shortname     | An SRL abbreviation          | sms, sm64, portal                     |
| Categories | ID            | A base 10 number             | 312, 1456, 11                         |
| Runs       | ID            | A base 36 number             | 1b, 3nm, 1vr                          |

Your code shouldn't care too much about what these attributes actually are, as they're all represented as unique
strings. But as a human it's nice to be able to glean some meaning out of them.

## Runners
A runner is a user who has at least one run tied to their account. Users with zero runs are not discoverable using the
API.
