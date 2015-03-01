# Out of Memory Tools

## BGZF

Section 4 of the [Sam Format
Specification](http://samtools.github.io/hts-specs/SAMv1.pdf) has details about
the BGZF format.

Peter Cock also has a [terrific
post](http://blastedbio.blogspot.com/2011/11/bgzf-blocked-bigger-better-gzip.html)
about this format on his blog [Blasted
Bioinformatics](http://blastedbio.blogspot.com/).

## Creating SQLite Databases

### GWAS Catalog Data

I've created a toy SQLite database from the NHGRI GWAS catalog. There are two
versions: an unnormalized table, and a more-normalized set of two tables.

The NHGRI [catalog of published GWA studies](http://www.genome.gov/gwastudies/)
can be downloaded from here: http://www.genome.gov/admin/gwascatalog.txt. This
file was downloaded 2014-09-07. Unfortunately, this file is quite messy so I've
taken a cleaner subset of entries. A big problem is that this data is
distributed as one (unnormalized) table, when it should be at least two tables
(studies and risk alleles associated with studies). To simplify examples, I've
used removed 542 rows (from 17,833) that don't have clean, single RS IDs for
the strongest risk SNP:

    $ gawk -F"\t" '$21 ~ /^rs[0-9]+-.? *$/' gwascatalog.txt > filtered_gwascatalog.txt

We use the risk allele column, since (unfortunately), the `SNPs` column has
some combined entries like: `rs11209002,rs2064689,rs1004819,rs2902440`.
Overall, we lose information but this makes the SQLite examples much simpler.
If you actually needed to process these data (not for a toy example), you could
write a script that parses and cleans the joined RS IDs. Ideally, the data
should be provided in a cleaner format that is more conducive to parsing.

For the first simple examples we use a quick script I wrote,
`gwascat2sqlite.py`, to create a table `gwascat` in a SQLite database
`gwascat.db` from the filtered GWAS catalog file.

    $ python gwascat2sqlite.py gwascat.db gwascat filtered_gwascatalog.txt

For other examples, we use GWAS Catalog split into two tables, so these tables
are normalized ([2NF](http://en.wikipedia.org/wiki/Second_normal_form)). These
two tables are `loci` and `schema`. We use Pubmed IDs as unique IDs, which they
are, according to:

    $ cat filtered_gwascatalog.txt | cut -f2 | uniq | sort | uniq -d

Note that there's a character encoding problem in the original
`gwascatalog.txt` -- this sort of stuff happens all the time. Using `cut` may
give you a warning and *incorrect results*. The issue here is that one or more
characters are UTF-8, which is not a single-byte encoding scheme. Setting your
shell to force C-style single byte support solves this:

    $ export LC_CTYPE=C
    $ export LANG=C

We can see these with the trick we learned in chapter 7:

    $ nonascii filtered_gwascatalog.txt

The two table database was generated with (this creates two tables, `loci`, and
`study`):

    $ gwascat2sqlite2table.py hs_variants.db filtered_gwascatalog.txt

#### Notes about these data

As one example to demonstrate grouping data and using SQLite functions, I look
at the maximum -log10 p-values per year. A clear (somewhat unsurprising) trend
emerges: -log10 p-values roughly increase over time. This is due to larger
study sample sizes. It'd be nice to get at the actual raw sample size
information. Unfortunately, while the `initial_samplesize` and
`replication_samplesize` columns include descriptive information about the
populations included in the study, the actual are not easily extractable
without loss of information.

### The Toy Joining Data

Teaching joins with real data is tricky, as there are far too many rows to show
full cross joins, add in complexities like NULLs, etc. I have created small toy
data sets `assocs.txt` and `studies.txt` in the directory `toy-joins/`. The
database `joins.db` is included in the main directory for easy access, but the
Makefile and `joins.sql` file used to create it are in `toy-joins/`.

### 1000 Genome Data

I've downloaded the file with:

    $ wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr19.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf.gz

and created a table `freqs_1kg` in `hs_variants.db`:

    $ vcf2sqlite.py hs_variants.db freqs_1kg \
       ALL.chr19.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf.gz

## More on SQLite Types

I've simplified some of my discussion of SQLite types, though paying careful
attention to not take it too far. The best, most definitive source is this page
of the SQLite documentation: http://www.sqlite.org/datatype3.html

So while I gloss over the finer details of SQLite storage classes and data
types, this isn't far enough from the truth that it's incorrect.

## Binning to improve overlap query performance in relational databases

The classic reference for this is [Kent et al.
(2002)](http://genome.cshlp.org/content/12/6/996.full) *The Human Genome
Browser at UCSC*. See Figure 7 and the surrounding discussion for more details.
There's also much more information and code examples at:
http://genomewiki.ucsc.edu/index.php/Bin_indexing_system.

Jim Kent's code uses very clever bit shift schemes that are (relatively) easily
implemented in other languages.

## Data for the SQLite +.import+ example

Given this is a chapter on databases, I couldn't resist using a database (UCSC
Genome Browser's MySQL database) to generate some data for an example on how to
import data into a database. See the SQL file `ucsc_example_vars.sql`, which
contains:

    SELECT chrom, chromStart, chromEnd, strand, name
    FROM snp137Common
    WHERE name IN("rs12255372", "rs333", "rs1333049", "rs4988235");

These are some popular RS ID's from the great site
[SNPedia](http://www.snpedia.com/index.php/SNPedia). This SQL grabs their
positions from the dbSNP track in UCSC. It can be executed using:

    $ mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A hg19 \
      < ucsc_example_vars.sql | sed 1d > variants.txt

## Database Normalization Resources

[E.F. Codd](http://en.wikipedia.org/wiki/Edgar_F._Codd) was the inventor of the
relational model and the normal forms. His [The relational model for database
management](http://dl.acm.org/citation.cfm?id=77708&CFID=560187979&CFTOKEN=80219131)
is available online for free, but is very technical. Jay Kreibich's [Using
SQLite](http://shop.oreilly.com/product/9780596521196.do) has a good short
treatment.

Date's writings ([Date on Database: Writings
2000-2006](http://www.amazon.com/Date-Database-Writings-2000-2006-C/dp/159059746X))
are interesting and show some of the disagreement with, and extensions of
Codd's definitions.

## In-memory Databases

SQLite also supports in-memory databases (which are faster than on-disk
databases, since memory IO is faster than disk IO). You can create these by
opening a connection to `:memory:` (rather than your normal SQLite3 file). For example, in Python, this would look like:

    con = sqlite3.connect(":memory:")

See [SQLite's documentation](https://www.sqlite.org/inmemorydb.html) for more
information. [Python's sqlite3 module documentation](https://docs.python.org/2/library/sqlite3.html) also covers an example.


## Python and SQLite3

I mention that you should always use
[placeholders](https://docs.python.org/2/library/sqlite3.html#sqlite3.Cursor.execute)
in SQL statements. Although the focus of this chapter is not creating and
working with databases open to the public, it's worth noting that not handling
query building correctly can lead to disastrous results. There's a classic
[xkcd](http://xkcd.com/327/) on this:

![](http://imgs.xkcd.com/comics/exploits_of_a_mom.png)

