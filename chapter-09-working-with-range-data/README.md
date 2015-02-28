# Ranges Chapter Supplementary Material

## A note on the Introduction

While the simple linear sequence representation of genomes begins to break down
when we consider structural variants like insertions, deletions,
translocations, copy number variants, etc. -- everything is better thought of
as a graph. There's exciting new work in representing and working with
sequences as graphs, e.g. the preprints [Dilthey et al.,
2014](http://biorxiv.org/content/early/2014/07/08/006973) and [Paten et al.,
2014](http://arxiv.org/abs/1404.5010).

## S4Vectors

As of writing this chapter, parts of the `IRanges` package are being [split
off](https://stat.ethz.ch/pipermail/bioc-devel/2014-April/005580.html) into the
new `S4Vectors` package. I only discuss these lower-level topics briefly, but
if you want more information see [the IRanges
vignette](http://bioconductor.org/packages/release/bioc/vignettes/IRanges/inst/doc/IRangesOverview.pdf)
and the [S4Vectors
page](http://www.bioconductor.org/packages/release/bioc/html/S4Vectors.html). I
don't link these directly in the book because these links and vignette content
may change.

## Files

- `Mus_musculus.GRCm38.75_chr1.gtf.gf` are chromosome 1 annotations extracted
  from `Mus_musculus.GRCm38.75.gtf.gz` downloaded from Ensembl's FTP
(ftp://ftp.ensembl.org/pub/release-75/gtf/mus_musculus) on 2014-08-02.

        gzcat Mus_musculus.GRCm38.75.gtf.gz | egrep "^(1\t|#)" | gzip > Mus_musculus.GRCm38.75_chr1.gtf.gf

- `mm10_snp137_chr1_trunc.bed.gz` is a randomly sampled, shorter version of
  `mm10_snp137_chr1.bed.gz` (since Github doesn't play well with large files).
`mm10_snp137_chr1.bed.gz` was downloaded from the UCSC Genome Browser's Table
Browser (http://genome.ucsc.edu/cgi-bin/hgTables). This was file was downloaded
on 2014-08-01. The truncated file was created with (you need GNU sort for this):

        $ gzcat mm10_snp137_chr1.bed.gz | sort --random-sort | head -n 2700000 | gzip > mm10_snp137_chr1_trunc.bed.gz



- `Mus_musculus.GRCm38_genome.txt` is a tab-delimited file of all chromosome
  lengths from the mm10/GRCm38 genome version. It was created with:

        curl ftp://ftp.ensembl.org/pub/release-75/fasta/mus_musculus/dna/Mus_musculus.GRCm38.75.dna_rm.toplevel.fa.gz \
        | bioawk -c fastx '{print $name"\t"length($seq)}' > Mus_musculus.GRCm38_genome.txt
