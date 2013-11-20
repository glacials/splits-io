# splits.io

splits.io is a website similar to Pastebin or GitHub Gist, but for splits
generated from speedruns rather than text or code. It's written in Ruby on
Rails.

## Development

splits.io is in development. The general bucket list is:

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
* Supply timeline charts for each set of splits (done)

### Parsers

#### Explanation

Each file format reader is implemented as an [LL parser][2], which means that
yes, we actually treat each format as its own context-free grammar. This means
we get to validate the data as we are reading it. It also means that it's pretty
simple to implement a new format (i.e. support a new splitting program). And as
icing on top, it becomes super easy to tell one splits format apart from
another when we need to parse.

As a simple example, we may have a rule that says something like

    TitleLine -> "Title=" Title Newline

which can be read as "a title line consists of the string 'Title=' followed by
a title (which we will define later), followed by a newline. So later on, we can
complete our definition by doing

    Title -> /([^,\r\n]*)/

which is just a regular expression that says "a title consists of any number of
characters which aren't commas or newline characters". All we have to do now is
define our `Newline` rule:

    Newline -> "\r\n"
             | "\n"

This just means that a newline can be Windows-style newline (`\r\n`) or a
Unix-style newline (`\n`). The parser will match whichever one it sees.

So if we have a line like

    Title=Sonic Colors

the `TitleLine` will match successfully, as it can see all three required
elements (assuming there is indeed a newline character afterwards). Let's try
out some splits. We'll look at the Time Split Tracker format now.

    Death Egg Robot	33.74
    /Users/glacials/split_images/sonic/death_egg_robot.png
    Perfect Chaos	1770.8
    /Users/glacials/split_images/sonic/perfect_chaos.png
    Egg Dragoon	2280.32
    /Users/glacials/split_images/sonic/egg_dragoon.png
    Time Eater	387.91
    /Users/glacials/split_images/sonic/time_eater.png

This is a bit more complicated. Each split has a title, a time, and a path to an
image on the user's local machine. Obviously we can't do anything about the
image path, but we should match against it anyway just to be thorough.

Additionally, in this format some elements are separated by tab characters
(e.g. the split title and time, if you didn't notice), while others are
separated by newlines.

Let's pretend we already have a rule somewhat like

    SplitLines -> Split SplitLines
                | Split

which reads "a `SplitLines` item should consist of a `Split` followed by another
`SplitLines` item, or of just a `Split`". This allows us to read in as many
splits as we can, because the rule will match against itself as many times as it
needs to.

So, let's match the splits themselves:

    Split -> Title Tab Time Newline ImagePath Newline

    Title     -> /([^\t]*)/
    Time      -> /(\d*\.\d*)/
    ImagePath -> /([^\r\n]*)/

    Tab     -> "\t"
    Newline -> "\n"
             | "\r\n"

By matching only against digit characters (`\d`) for our times, we immediately
fail the parse if we see anything we're not expecting, instead of checking (or
worse, forgetting to check) the values later down the line.

When we perform this parse on a split from Time Split Tracker, we should get an
object in return that we can call things like `split.title` and `split.time` on.

#### In the code

To accomplish all this, we use the parser generator [Babel-Bridge][3], which is
available in a neat little gem. Check out the actual implementations of all this
stuff in the `lib/<name-of-splitting-program>Parser.rb` files.

[1]: https://github.com/skoh-fley/splits.io/blob/master/lib/wsplit_parser.rb
[2]: http://en.wikipedia.org/wiki/LL_parser
[3]: https://github.com/shanebdavis/Babel-Bridge
