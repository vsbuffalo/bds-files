# Pipelines

## Internal Field Separator (IFS)

In discussing how spaces can complicate certain Unix operations (e.g. in `ls`
with wildcards), I've skipped mentioning the [Internal Field Separator
variable](http://en.wikipedia.org/wiki/Internal_field_separator) to keep things
simple. This is an advanced topic, but may interest some readers.

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
