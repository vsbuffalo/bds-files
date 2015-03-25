# Pipelines

## Internal Field Separator (IFS)

In this chapter I briefly introduce the [Internal Field Separator
variable](http://en.wikipedia.org/wiki/Internal_field_separator) (or IFS). The
IFS is how Bash splits *fields* into words. This is important in creating Bash
Arrays — Bash will use `IFS` to tokenize a string into array elements. For
example (using the `files.txt` in this directory):

    $ cat files.txt
    file_A
    file_B
    file_C
    file D

Note the last line has a space. Look what happens if we load these values into
a Bash array:

    $ all_files=($(cut -d"  " -f1 files.txt)) # -d "	" is a literal tab character
                                              # created with control-v <tab>

    $ for file in "${all_files[@]}"; do echo $file; done;
    file_A
    file_B
    file_C
    file
    D

`file D` was tokenized into `file` and `D`. This is because `IFS` includes
space (here are a few ways of looking at `$IFS`):


    $ echo -n "$IFS" | hexdump -c # use echo -n to not append newline
    0000000      \t  \n
    0000003

    $ printf %q "$IFS"
    $' \t\n'

The best way to avoid this is **to not have filenames with spaces in them**.
Still, in some cases you may need to process poorly named files (this is
bioinformatics, after all), so you can temporarily set `IFS` to just tabs and
newlines (or better, just newlines). Remember to restore the default IFS!
Here's an example:

    $ OFS="$IFS" # store original field separator to restore later
    $ IFS="\n" # set new IFS
    $ all_files=($(cut -d"  " -f1 files.txt))
    $ for file in "${all_files[@]}"; do echo $file; done;
    file_A
    file_B
    file_C
    file D
    $ IFS="$OFS"

You can also set `IFS` to commas or semicolons where appropriate.


## On the Danger of Command Substitution and Looping over Files

In this chapter, to loop through files with a Bash `for` loop, I first load
files into an array using command substitution, and then loop through with
`${bash_array[@]}`. As with anything in computing, there are more than one ways
to do this. And as with anything in Bash, there are numerous pitfalls you
should be aware of. Here's why the book teaches the approach it does;

Using direct command substitution in a `for` loop like:

    for file in $(ls *.fastq); do
      echo $file
    done

is [a common Bash pitfall](http://mywiki.wooledge.org/BashPitfalls#pf1). I like
to explicitly load these values into an array using a **quoted** command
substitution, and loop through each element with `"${bash_array[@]}"`. I find
being explicit indicates what's going on — Bash is using *word splitting* with
the `IFS`, and this could lead to unsafe behavior if you have files with
filenames containing spaces, newlines, tabs, or globbing characters.

However, this is not universally robust against all filenames; only more
explicit. **In general, this is only safe with clean filenames: filenames
cannot contain spaces, newlines, tabs, or globbing charcters like `*`!**. For
example, if you have spaces in your filename, you may need to set `IFS`:

    $ OFS="$IFS"
    $ all_files=($(cut -f1 files.txt))
    $ IFS="\n"; all_files=($(cut -f1 files.txt))
    $ for file in "${all_files[@]}"; do echo $file; done;
    file_A
    file_B
    file_C
    file D
    $ IFS="$OFS" # restore IFS

Note that we now also need to quote `"${all_files[@]}"` (which we didn't in the
book because our filenames don't have spaces) to make this work correctly! Try
this without quotes to see for yourself.

Many Bash experts will suggest not using command substitution at all to get
files to loop over. I don't disagree, but at a certain point we need to move
forward with work and get the job done rather than worrying about all corner
cases. Most sysadmins write Bash scripts that need to process files in users'
directories and they cannot make *any* assumptions about filenames. In
bioinformatics, we usually working with data files we name or can rename, so we
can exercise more control over filenames to prevent these corner cases. Still,
we are making an assumption about our data that could break code, so beware!
Bash's design is bad here; note this difficulty and keep it in the back of your
head.

Overall, Bash is meant for quick and dirty scripts; if you need more safety,
use Python.

More on this topic:

 - [A StackOverflow
   post](http://stackoverflow.com/questions/3348443/a-confusion-about-array-versus-array-in-the-context-of-a-bash-comple)
about `${bash_array[@]}` versus `${bash_array[*]}`.

 - [A nice LinuxJournal](http://www.linuxjournal.com/content/bash-quoting) post
   about quoting in Bash.

 - You can also use [read](http://stackoverflow.com/a/23357277/147427) with
   null-delimited lines (as we do in the chapter with `find` and `xargs`) but I
believe this is too confusing to teach in the book. New versions of Bash also
have the [mapfile](http://wiki.bash-hackers.org/commands/builtin/mapfile) and
readarray commands for this.


## Bash's `set -e`

There's a lot to Bash's `set -e` which I don't have the space to cover in the
book. Not all commands obey `set -e`, with the most clear example being
commands in the `if` conditional. More on this can be found on the [Bash FAQ
page](http://mywiki.wooledge.org/BashFAQ/105).

## Extended Test Syntax

I don't mention this in the book (to keep things simple), but Bash versions
greater than 2.02 support an *extended test syntax* based on double brackets
like `[[ ... ]]`. This syntax has support for common operators like `<`, `>`,
`&&` and `||`.

## Makefile Example

If you want to checkout another Makefile example see
`chapter-11-alignment/celegans-reads/Makefile` for an example of how a
read-creating pipeline.
