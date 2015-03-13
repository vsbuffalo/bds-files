# Resources for Chapter 8 - A Rapid Introduction to the R Language

## The "The Influence of Recombination on Human Genetic Diversity" Dataset

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

Data for the repeat examples was created with:

    $ zgrep "chrX" motif-example/data/rmsk.txt.gz | awk -v "OFS=\t" \
        'BEGIN {print "bin","swScore","milliDiv","milliDel","milliIns","genoName", \ 
    	"genoStart","genoEnd","genoLeft","strand","repName","repClass","repFamily", \
    	"repStart","repEnd","repLeft","id"} {print $0}' | gzip > chrX_rmsk.txt.gz

## A Note About `ifelse()`:

`ifelse()` is readable and clear, but just as note — it can be slower than the
following:

    > x <- c(-3, 1, -5, 2)
    > y <- rep(1, length(x))
    > y[x < 0] <- -1
    > y
    [1] -1  1 -1  1

## Pre-allocating vectors

I don't have the space to introduce all important R concepts in this chapter,
but one point worth mentioning is that if you do need to loop over a structure
with a `for` or `while` loop, always *preallocate* your results vector. You can
create empty numeric vectors with `numeric(len)` and empty integer vectors with
`integer(len)`, where `len` is the length. For example, if you were to loop
over too vectors to sum their values pairwise, do not use:

    x <- rnorm(10)
    y <- rnorm(10)
    res <- NULL
    for (i in 1:length(x)) {
      res <- c(res, x[i] + y[i])
    }

First, this is completely unecessary since we could calculate this with `res <-
x + y`. Second, even if our `for` loop did some computation we couldn't do with
vectorized operations (e.g. the current step depends on the last step's value),
this code would be needlessly slow because appending to vectors with `res <-
c(res, ...)` is extremely computationally expensive in R.

R's vectors are allocated in memory to the _exact_ length that the need to be.
So each iteration of the above code requires (1) allocating a new `res` vector
one element longer, and (2) copying all of `res`'s current elements over to
this new vector. Since this new vector is only one element longer, it's only
long enough for this iteration -- guaranteeing we need to allocate a new vector
the next iteration and copy everything over again! In contrast Python's lists'
`list.append()` operation is fast, because each vector is [geometrically
expanded](http://en.wikipedia.org/wiki/Dynamic_array#Geometric_expansion_and_amortized_cost).

The correct way to do this (assuming in your real code something in the `for`
loop can't be parallelized!) is:

    x <- rnorm(10)
    y <- rnorm(10)
    res <- numeric(10) # preallocation!
    for (i in 1:length(x)) {
      res[i] <- x[i] + y[i]
    }

## HapMap Hotspot Data for the Data Combining Example

I use HapMap recombination hotspots on hg17 in this example. The very simple
file `split_hotspots.R` takes this file and splits `hapmapRecombHotspots.bed`
by chromosome.

    $ wget http://hgdownload.soe.ucsc.edu/goldenPath/hg17/database/hapmapRecombHotspots.txt.gz
    $ gzcat hapmapRecombHotspots.txt.gz | cut -f2-4 > hapmapRecombHotspots.bed
    $ Rscript split_hotspots.R

## RStudio Resources

![Image of RStudio](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/rstudio-image.png)

See the [full-sized image here](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/rstudio-image.png).

See RStudio's
[documentation](https://support.rstudio.com/hc/en-us/sections/200107586-Using-RStudio)
for more information on how to use RStudio to its fullest potential. RStudio
has also created a very useful set of
[cheatsheets](http://www.rstudio.com/resources/cheatsheets/) on topics like
data wrangling and RMarkdown.


