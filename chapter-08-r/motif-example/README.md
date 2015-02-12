# Data and Steps to Reproduce the Recombination Motif Example

The purpose of this example is to illustrate how simple it can be to replicate a
finding (especially a very important one) with the proper bioinformatics tools
and skills.

A note about hg16: To be consistent with other data in this chapter (and the
papers it comes from), I use hg16. The purpose here is simply to replicate
results, and not necessarily on the newest genome version.

## Getting Repeat Positions

Download recombination rate file and convert to BED3:

    $ mkdir data; cd data
    $ wget http://hgdownload.soe.ucsc.edu/goldenPath/hg17/database/hapmapRecombRate.txt.gz
    $ gzcat hapmapRecombRate.txt.gz | cut -f2-5 > hapmapRecombRate.bed

It's important to think about whether files downloaded are in 0-based or 1-based
coordinates in actual work. UCSC displays tracks in
[1-based but internally represents them as 0-based](https://genome.ucsc.edu/FAQ/FAQtracks.html#tracks1).

Download RepeatMasker files from UCSC:

    $ wget http://hgdownload.soe.ucsc.edu/goldenPath/hg17/database/chr{1..22}_rmsk.txt.gz
	$ wget http://hgdownload.soe.ucsc.edu/goldenPath/hg17/database/chr{X,Y}_rmsk.txt.gz
    $ cat *_rmsk.txt.gz > rmsk.txt.gz

Grab the THE1B and L2 repeats from the RepeatMasker file `rmsk.txt.gz`:

    $ zgrep THE1B data/rmsk.txt.gz | cut -f6-8 | awk -v"OFS=\t" '{print $1,$2,$3+1, "THE1B"}' > data/hotspot_repeats.bed
    $ zgrep L2 data/rmsk.txt.gz | cut -f6-8 | awk -v"OFS=\t" '{print $1,$2,$3+1, "L2"}' >> data/hotspot_repeats.bed

## Finding THE1B Motifs in the Genome

I wrote a *very* quick script called `find_motifs.py` that uses simple regular
expressions to find motifs. This is a quick implementation (e.g. I would do more
testing before using this in other applications or for serious research) -- but
that said it works well for this quick example. Run:

    $ # from motifs-example/
    $ python find_motifs.py hg17.fa CCTCCCTGACCAC CCTCCCTGACCAC > data/motifs.bed
    $ python find_motifs.py hg17.fa CCTCCCTAGCCAC CCTCCCTAGCCAC >> data/motifs.bed

This requires you download and merge hg16 files first - these are too big to
include in this repo. This is easy; download all chromosomes and do `cat *.fa >
hg16.fa`.

## Repeat Masker File for the `%in%` Example
