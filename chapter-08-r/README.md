# Resources for Chapter 8 - A Rapid Introduction to the R Language



## Exploring the Data in "The Influence of Recombination on Human Genetic Diversity"


The original article *The Influence of Recombination on Human Genetic
Diversity* by Spencer et al., 2006 is available from [PLOS
Genetics](http://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.0020148).

### `Dataset_S1.txt`

`Dataset_S1.txt` contains SNPs, diversity, recombination, and other metrics in
1kb windows along chromosome 20 of the human genome. You can download
`Dataset_S1.txt` from the [Supplementary
Information](http://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.0020148#s5)
section of this article. I've also included a copy in this Github directory by
the same name. Please see the file description in the supplementary information
section of the paper for details about this file.

**Note: the positions in this data set are in human genome build 34 (hg16)
coordinates)**

Columns are:

- `start`: window start

- `end`: window end

- `total SNPs`: number of SNPs called across window

- `total Bases`: total bases sequenced that map to window

- `depth`: average read depth within window

- `unique SNPs`: number of unique SNPs (i.e., nonredundant set)

- `dbSNPs`: umber of "double-hit" SNPs (where both alleles have been observed two or more times)

- `reference Bases`: number of non-N bases in the reference sequence in the window

- `Theta`: estimate of theta

- `Pi`: estimate of Pi

- `Heterozygosity`: Estimate of heterozygosity

- `%GC`: Percent GC

- `Recombination`: Recombination fraction for window (cM)

- `Divergence`: Percent sequence identity between human and chimpanzee (panTro1)

- `Constraint`: Number of bases in window identified as being in an exon

- `SNPs`: Number of SNPs typed in genotyping study within window.

Please see supplementary Text S1. for details on how Pi and other statistics
are calculated. This document also says that these values are reported as x10
their original values.

### Centromere Regions from Cytobands

The centromere regions come from [Giemsa
banding](http://en.wikipedia.org/wiki/G_banding) data available for hg16 from
the UCSC Genome Browser. A delightful bit of Unix hackery provides these
coordinates. First, you cold download the entire table (which is useful)
directly with:

    $ wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg16/database/cytoBand.txt.gz"

If you haven't UCSC's `cytoBand.txt.gz` files and aren't familiar with the
format, I'd recommend doing this and poking around with `less`.

But we only care about the two ranges for chromosome 20 for the centromere
band. There are two ranges: one for the q arm, and one for p. The band type
(fifth column) for centromeres is "acen". So we use:


    $ curl -s "http://hgdownload.cse.ucsc.edu/goldenPath/hg16/database/cytoBand.txt.gz" \
        | zgrep "acen" | grep "chr20"
    chr20	25800000	27800000	p11.1	acen
    chr20	27800000	29700000	q11.1	acen

Our centromere position is thus the start position of the leftmost p arm
(25,800,000) and the end position of our rightmost q arm (29,700,000).

## Repeat Data

    $ zgrep "chrX" motif-example/data/rmsk.txt.gz | awk -v "OFS=\t" \
        'BEGIN {print "bin","swScore","milliDiv","milliDel","milliIns","genoName", \ 
    	"genoStart","genoEnd","genoLeft","strand","repName","repClass","repFamily", \
    	"repStart","repEnd","repLeft","id"} {print $0}' | gzip > chrX_rmsk.txt.gz
