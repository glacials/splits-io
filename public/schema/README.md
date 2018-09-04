# Splits I/O JSON Schema
The Splits I/O JSON Schema is a standard way of arranging run information in JSON.

[**Documentation**][1]

[**Raw JSON Schema**][2]

## Examples
The schema is large, but many fields are optional -- a run at its heart resembles the following:

```json
{
  "_schemaVersion": "v1.0.0",
  "timer": {
    "shortname": "livesplit",
    "longname":  "LiveSplit",
    "version":   "v1.6.0"
  },
  "game":     {"longname": "Super Mario Odyssey"},
  "category": {"longname": "Any%"},
  "segments": [
    {
      "name":         "Cap",
      "endedAt":      {"realtimeMS": 143123},
      "bestDuration": {"realtimeMS": 141167}
    }
  ]
}
```

However you likely want to add some additional fields to contain previous attempts, skipped splits, and runner
information. For details around all possible fields, see the [documentation][1]. If you like, you can plug the raw
schema itself into your program for validation -- it's written in [json-schema][3], so any json-schema library will be
able to handle it.

[1]: http://lbovet.github.io/docson/index.html#https://raw.githubusercontent.com/glacials/splits-io/master/public/schema/run_v1.0.0.json
[2]: https://raw.githubusercontent.com/glacials/splits-io/master/public/schema/run_v1.0.0.json
[3]: http://json-schema.org/
