# Chapter 10: Sequence Data

## Files

 - `egfr_flank.fasta` comes from Ensembl (see below).

 - `contam.fastq` is used as an example FASTQ file. It's the same file we used
   in chapter 7 for `less` examples.

 - Heng Li's `readfq.py`, downloaded from
   https://github.com/lh3/readfq/blob/master/readfq.py. See it's commit
history, which is mentioned in the book:
https://github.com/lh3/readfq/commits/master/readfq.py

 - `untreated1_chr4.fq`: a FASTQ file generated from the
   [pasillaBamSubset](http://www.bioconductor.org/packages/release/data/experiment/html/pasillaBamSubset.html)
file `untreated1_chr4.bam`.

## egfr_flank.fasta File

The example FASTA file was downloaded from the Ensembl biomart interface. This
example file contains the upstream flanking regions (only 200bp, so the example
prints in a single page width) for the mouse Epidermal growth factor receptor
(Egfr) gene. The biomart query in XML format is:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Query>
<Query  virtualSchemaName = "default" formatter = "FASTA" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" >
  <Dataset name = "mmusculus_gene_ensembl" interface = "default" >
    <Filter name = "upstream_flank" value = "200"/>
    <Filter name = "ensembl_gene_id" value = "ENSMUSG00000020122"/>
    <Attribute name = "ensembl_gene_id" />
    <Attribute name = "ensembl_transcript_id" />
    <Attribute name = "transcript_flank" />
  </Dataset>
</Query>
```

I've formatted the file with the following:

    seqtk seq -l 60 mart_export.txt.gz > egfr_fank.fasta

## Base Qualities

The quality line used in examples is:

    JJJJJJJJJJJJGJJJJJIIJJJJJIGJJJJJIJJJJJJJIJIJJJJHHHHHFFFDFCCC

If you want to copy and paste it and try converting yourself.

## Indexed FASTA Files

This example uses the mouse genome (Ensembl release 75) for an example. You can
get this with:

    $ wget ftp://ftp.ensembl.org/pub/release-75/fasta/mus_musculus/dna/Mus_musculus.GRCm38.75.dna.toplevel.fa.gz

## untreated1_chr4.fq

Created a FASTQ file from:

    $ samtools view untreated1_chr4.bam | \
     bioawk -c sam '{s=$seq; q=$qual; if(and($flag, 16)) {s=revcomp($seq);q=reverse($qual)} print "@"$qname"\n"s"\n+\n"q}' > untreated1_chr4.fq

## CASAVA Manual

Much, much more information about the FASTQ format produced by Illumina's CASVA
base calling and read processing pipeline can be found in the [CASAVA
manual](http://supportres.illumina.com/documents/myillumina/212b4ea1-8658-4505-9b42-008eb0a8b300/casava_qrg_15011197c.pdf).

### FASTA Extraction Benchmarks

Note that `extract.py` suffers some limitations. First, this script is not
robust to regions that are in the correct format -- we never explicitly check
that the regular expression matches `region`. This is an easy fix; we could
either check the object returned from `re.match()` is not `None` or wrap the
statement in a `try/except` block. Second, this script does not do explicit
bounds checking, meaning the user would not be warned if they tried to access a
range outside the sequence length.

TODO seqtk comparison
