# Chapter 11 - Working with Alignment Data

## A note about Samtools versions

This book requires the [latest Samtools](http://www.htslib.org/); in the book
I've used:

    $ samtools --version
    samtools 1.2
    Using htslib 1.2
    Copyright (C) 2015 Genome Research Ltd.

Older versions require some flags that are now unnecessary, like `-S` with
`samtools view` to specify input is a SAM file (now filetype is autodetected).

## `celegans.sam` and `celegans.bam`

Both of these sample files were simulated -- see the directory
`celegans-reads/`, the readme `celegans-reads/README.md`, and
`celegans-reads/Makefile`. Chapter 12 of the book covers Makefiles if you're
curious about this.

## `NA12891_CEU_sample.bam` Sample BAM File

The `NA12891_CEU_sample.bam` sample BAM file is from region
chr1:215,622,894-216,423,396, which is gene
[USH2A](http://uswest.ensembl.org/Homo_sapiens/Gene/Summary?db=core;g=ENSG00000042781;r=1:215622894-216423396).
The alignment data comes from the [1000 Genomes
Project](http://www.1000genomes.org), and the file was created with:

    $ samtools view -hb ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/pilot2_high_cov_GRCh37_bams/data/NA12891/alignment/NA12891.chrom1.ILLUMINA.bwa.CEU.high_coverage.20100517.bam \
      1:215622894-216423396 > NA12891_CEU_sample.bam

Note that this illustrates that `samtools view` can work with (sorted and indexed) BAM files over networks.

## USH2A Region

I chose this region because it's of significant [medical
importance](http://en.wikipedia.org/wiki/Usher_syndrome) and has interesting
biology. The mismatches I discuss (positions 215,906,547 and 215,906,548) in
this chapter were chosen for the sake of a technical example to illustrate how
useful visual inspection of SNPs is). These mismatches are likely false
positive variant calls due to common technical issues in base calling and
alignment.

See http://genomewiki.ucsc.edu/index.php/USH2A_SNPs for more information on
this gene.

## The 1000 Genomes Reference

The reference genome used by the 1000 Genome Project (and the reference for
file `NA12891_CEU_sample.bam`) is too large to include in this Github
repository, but it can be accessed with:

    $ wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz

You'll need to unzip this file using `gunzip`, since indexing with `samtools
faidx` doesn't work with gzipped files. In chapter 13, we learn about
compression files with BGZF, which are compatible with `samtoolsa faidx`. This
is too complex for this chapter, so I ignore it.

After unzipping the file with `gunzip`, you should end up with a file
`human_g1k_v37.fasta` that's 2.9GB and has SHA-1
`d83eb9744f59bc6e9edd0ae4006bd39d693bc0a2`.

## Converting between hexidecimal, binary, and decimal

A good tutorial to get started with binary and hexidecimal, and converting
between these values is:
http://www.learning-about-computers.com/tutorials/binary_and_hexidecimal.shtml

Note that Google can convert values for you too. If you [Google 0x139 in
binary](https://www.google.com/search?q=0x93+in+binary&oq=0x93+in+binary&aqs=chrome..69i57j69i60l3.204j0j4&sourceid=chrome&es_sm=91&ie=UTF-8)
or [0x139 in
decimal](https://www.google.com/search?q=0x93+in+binary&oq=0x93+in+binary&aqs=chrome..69i57j69i60l3.204j0j4&sourceid=chrome&es_sm=91&ie=UTF-8#q=0x93+in+decimal),
Google will convert these for you. The OS X Calculator in programmer mode also
includes a handy converter.

## Installing IGV

If you're on a Mac, you'll first need to install Java. For Java on Yosemite,
see http://support.apple.com/kb/DL1572. Then, install IGV through
[Homebrew](http://brew.sh/) by (1) tapping the Homebrew science keg and (2)
installing it with `brew install`:

    $ brew tap homebrew/science
    $ brew install igv

If you're on a Linux machine with `apt-get`, use:

    $ sudo apt-get install igv

If you cannot install IGV through your package manager, IGV is also available
as a Java Web Start application (though this is not recommended for OS X
Mountain Lion and more recent OSes). See
http://www.broadinstitute.org/software/igv/download for more information on
starting IGV this way. The Java Web Start version of IGV is available with
different memory configurations; see IGV's website for more detail.

### IGV Command Line Program

`igv` is a small shell wrapper; you can view it's source with:

    $ cat `which igv`
    #!/bin/sh
    
    #This script is intended for launch on *nix machines
    
    #-Xmx2000m indicates 2000 mb of memory, adjust number up or down as needed
    #-Dproduction=true disables non-released and development features
    #Script must be in the same directory as igv.jar
    #Add the flag -Ddevelopment = true to use features still in development
    prefix=/usr/local/Cellar/igv/2.3.34/libexec
    exec java -Xmx2000m \
      -Dapple.laf.useScreenMenuBar=true \
      -Djava.net.preferIPv4Stack=true \
      -jar "$prefix"/igv.jar "$@"

The current version is a bit rough around the edges (e.g. you'd have to
manually tweak the wrapper just to increase the amount of memory used), but is
more friendly than starting the application with Java alone.

## IGV Copyable Region

To make it easier to copy and paste, here's the region used in our IGV example:
`1:215,906,528-215,906,567`.

## VCF Format Information

I thought it would be insane to spend pages describing the VCF format in a
book; it's likely to change, projects like 1000 Genomes use their own versions,
and it may be replaced at some point. For more information, see:

 - The [HTS-Specs Github page](https://github.com/samtools/hts-specs) for the official specification.

 - The [VCF Wikipedia page](http://en.wikipedia.org/wiki/Variant_Call_Format) for general information.

Also, David Haussler gave a terrific talk on future directions in creating (and
mapping to) a universal human reference genome at the Simon's Institute. In
[the beginning of the talk](https://www.youtube.com/watch?v=Hq0SP7EraxY) he
discusses some problems with the VCF format.

## More VCF Genotype representation

There's numerous other useful genotype VCF fields I didn't cover, such as `GQ`,
`AD`, and `DP`. I really like GATK's documentation [on this
subject](http://gatkforums.broadinstitute.org/discussion/1268/how-should-i-interpret-vcf-files-produced-by-the-gatk)
— it's clear and very well written.
