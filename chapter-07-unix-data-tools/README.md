# Resources for Chapter 7 -- Unix Data Tools

Bentley's *Programming Pearls* column with Donald Knuth and Doug McIlroy is
available on the [ACM website](http://dl.acm.org/citation.cfm?id=5948.315654).
One particularly excellent quote from McIlroy that I didn't include is:

> Knuth has shown us here how to program intelligibly, but not wisely. I buy
> the discipline. I do not buy the result. He has fashioned a sort of
> industrial-strength Fabergé egg -- intricate, wonderfully worked, refined
> beyond all ordinary desires, a museum piece from the start.

<!--

leftover:
grep "^#" -v Mus_musculus.GRCm38.75_chr1.gtf | awk '{if ($3=="gene" && $2 == "protein_coding") { print $0 }}' | cut -f 9 | sed 's/; / /g' | sed 's/ / /g' | cut -f2,4 | sed 's/"//g' > Mus_musculus.GRCm38.75_chr1_genes.txt

contam.fastq -- shorter version (used in book so examples print more clearly) -->

## Regular Expressions

![xkcd 1171](http://imgs.xkcd.com/comics/perl_problems.png)

There's numerous good resources on Regular Expressions, but one of the best ways to tackle regular expression problems is with an interactive debugger like:

 - [regular expressions 101](https://regex101.com/)
 - [Debbugex](https://www.debuggex.com/)

## A note about the `Mus_musculus.GRCm38.75_chr1.bed` file

There's a subtle (yet exceedingly common in bioinformatics) [off by
one](https://en.wikipedia.org/wiki/Off-by-one_error) error in this file
(sorry!). I thought about fixing it during the book editing process, but
actually think it's a valuable lesson, so I'll keep it in there. Can you find
out what it is?

If you need a hint: read chapter 9's section genomic range formats and use
`shasum` to compare the `test.txt` file to `Mus_musculus.GRCm38.75_chr1.bed`.

## Dealing with a Variable Number of Spaces

Plaintext data that uses a variable number of spaces to delimit columns looks
clean in the terminal but can be a nightmare to parse. Still, some programs
will occasionally output data this way (usually to provide easily readable data
to users). However, data in this format will *not* work with Unix data tools
like `cut`; it first needs to be converted to tab-delimited (or CSV). Using the
tool `sed` this is quite easy:

    $ sed 's/ */	/g' badly_formatted.txt > tab_delimited.txt

Note that the character between `/  /` is a literal tab (you can enter this in
your shell using control-w <tab>). However, note that this will introduce a
slew of problems if your columns themselves have spaces in them (which can
common in data). This why tab-delimited and CSV formats are preferable to
variable spaces.

## Grep Tricks

Here's an interesting `grep` trick to make it [50 times
faster](https://blog.x-way.org/Linux/2013/12/15/Make-grep-50x-faster.html).

## Parsing GTF Group Column with Awk/Bioawk vs Python

This can be quite messy... consider:

      bioawk -c gff '$3 ~ /gene/ && $2 ~ /protein_coding/ \
          {split($group, a, "; ");                        \
          print $seqname,$end-$start, a[1]}' Mus_musculus.GRCm38.75_chr1.gtf | \
          sed -e 's/gene_id //' -e 's/"//g'

This assumes that gene name will always be in the first column of group (a safe
assumption for well-formatted GTFs).

I may take the time to do this with Python. For example, the last column can
easily be turned into a dictionary with:

    group = 'gene_id "ENSMUSG00000090025"; gene_name "Gm16088"; gene_source "havana"; gene_biotype "pseudogene";'
    def parse_keyvals(x):
        key, val = x.split(" ")
        return (key, val.replace('"', ''))

    keyvals = dict([parse_keyvals(x) for x in group.strip(";").split("; ")])

    # keyvals:
    # {'gene_source': 'havana', 'gene_biotype': 'pseudogene', 'gene_name': 'Gm16088', 'gene_id': 'ENSMUSG00000090025'}

## Conclusion

If you're interested in where the "one feverish night" quote came from, it's
from a document by [Doug
McIlroy](http://doc.cat-v.org/unix/unix-reader/reader.pdf).
