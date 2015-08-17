## Parsing run files
Each timing program serializes runs into files differently. We want to be able to read all these formats, and most of
them are proprietary (simple, but proprietary nonetheless; LiveSplit, which serializes to XML, is the only exception
here -- on both counts).

For example, here's what a WSplit file looks like:

    Title=Sonic Colors
    Attempts=9
    Offset=0
    Size=152,25
    Rotatatron,0,501.7,462.85
    Captain Jelly,0,1256.61,719.44
    Frigate Orcan,0,2019.15,762.54
    Refreshinator,0,2700.42,681.27
    Admiral Jelly,0,3755.13,1054.71
    Frigate Skullian,0,4728.22,973.09
    Egg Nega Wisp,0,5039.02,310.8
    Epilogue,0,5083.74,44.7199999999993
    Icons="","","","","","","",""

It's a bit of a combination of some string-only key/value store, similar to an INI file, and a CSV file. Other timers'
formats are similarly simple, but never quite the same.

To read these different file types, we implement a bunch of very simple [LL parsers][2], treating each format as its own
context-free grammar.

### Example
Let's say we have a rule that says something like

    TitleLine -> "Title=" Title Newline

which can be read as "a title line consists of the string `Title=` followed by a title (which we will define later),
followed by a newline. So later on, we can complete our definition by doing

    Title -> /([^,\r\n]*)/

which is just a regular expression that says "a title consists of any number of characters which aren't commas or
newline characters". All we have to do now is define our `Newline` rule:

    Newline -> "\r\n"
             | "\n"

This just means that a newline can be Windows-style newline (`\r\n`) or a Unix-style newline (`\n`). The parser will
match whichever one it sees.

So if we have a line like

    Title=Sonic Colors\n

the `TitleLine` will match successfully, as it can see all three required elements. Let's try out some splits. We'll
look at the Time Split Tracker format now.

    Death Egg Robot	33.74
    /Users/glacials/split_images/sonic/death_egg_robot.png
    Perfect Chaos	1770.8
    /Users/glacials/split_images/sonic/perfect_chaos.png
    Egg Dragoon	2280.32
    /Users/glacials/split_images/sonic/egg_dragoon.png
    Time Eater	387.91
    /Users/glacials/split_images/sonic/time_eater.png

This is a bit more complicated. Each split has a title, a time, and a path to an image on the user's local machine.
Obviously we can't do anything about the image path, but we should match against it anyway just to be thorough.

Additionally, in this format some elements are separated by tab characters (e.g. the split title and time, if you didn't
notice), while others are separated by newlines.

Let's pretend we already have a rule somewhat like

    SplitLines -> Split SplitLines
                | Split

which reads "a `SplitLines` item should consist of a `Split` followed by another `SplitLines` item, or of just a
`Split`". This allows us to read in as many splits as we can, because the rule will match against itself as many times
as it needs to.

So, let's match the splits themselves:

    Split -> Title Tab Time Newline ImagePath Newline

    Title     -> /([^\t]*)/
    Time      -> /(\d*\.\d*)/
    ImagePath -> /([^\r\n]*)/

    Tab     -> "\t"
    Newline -> "\n"
             | "\r\n"

By matching only against digit characters (`\d`) for our times, we immediately fail the parse if we see anything we're
not expecting, instead of checking (or worse, forgetting to check) the values later down the line.

When we perform this parse on a split from Time Split Tracker, we should get an object in return that we can call things
like `split.title` and `split.time` on.

### In the code
To accomplish all this, we use the parser generator [Babel-Bridge][2], which is available in a neat little gem. Check
out the actual implementations of all this stuff in the `app/models` folder. 

[1]: http://en.wikipedia.org/wiki/LL_parser
[2]: https://github.com/shanebdavis/Babel-Bridge
