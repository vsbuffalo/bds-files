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

I've created a toy SQLite database from the NHGRI GWAS catalog and dbSNP.

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
should be provided in a cleaner format.

For other examples, we use GWAS Catalog split into two tables, so these tables
are normalized ([2NF](http://en.wikipedia.org/wiki/Second_normal_form)).

    $ cat filtered_gwascatalog.txt | cut -f2 | uniq | sort | uniq -d


The dbSNP Common SNP (release 137) file was downloaded from UCSC's Genome
Browser (because it's in a convenient tab-delimited format). The full schema is
[here](http://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=varRep&hgta_track=snp137Common&hgta_table=snp137Common&hgta_doSchema=describe+table+schema).

This file is too large to check into Github, so I've taken all chromosome 1
entries:

    $ gzcat snp137Common.txt.gz | awk '$2 ~ /chr1$/' | gzip > snp137Common_chr1.txt.gz

Then, we use the script `dbsnp_gwascat_to_sqlite.py` to clean these files, and
split the `strongest_snp_risk_allele` column in the GWAS catalog into SNP and
allele (again, makes toy examples easier):

    $ dbsnp_gwascat_to_sqlite.py snp137Common_chr1.txt.gz filtered_gwascatalog.txt


### A Note on MySQL and SQLite Types

In our simple conversion script, we change MySQL's `ENUM` and `SET` types to
SQLite's `TEXT` type. This is the simplest solution and works fine for this
particular application. However, note that this is in no way generally the best
solution. If we need stricter `ENUM` and `SET`-like types in our SQLite
database, another option is to use `INTEGER` in the SQLite table as a key to
another table's values. This complicates queries, but is a closer approximation
to `ENUM` and `SET` types.



