## splitsbin

splitsbin is a website similar to Pastebin or GitHub Gist, but for splits
generated from speedruns rather than text or code.

### Development

splitsbin is in development. The general bucket list is:

* Be able to parse splits from all popular splits programs (WSplit, Llanfair,
  Time Split Tracker, SplitterZ, etc.)
  * Each splits format interpreter is implemented as an LL parser using
    Babel-Bridge (see the [WSplit parser][1] for an example). This means
    supporting a new file format is mostly just a matter of writing the
    grammar.
* Be able to upload files by dragging and dropping them onto any page, similar
  to Imgur (done)
* Registration shouldn't be requried to upload splits
* Allow users to log in using their Twitch account (done, just in another
  project for now)
* Supply short-ish permalinks to every uploaded set of splits (done)
* Supply timeline charts for each set of splits (done, also in another project)

[1]: https://github.com/skoh-fley/splitsbin/blob/master/lib/wsplit_parser.rb
