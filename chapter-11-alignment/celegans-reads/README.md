# Simulated C. Elegans Reads

Our example SAM/BAM files for understanding the format come from re-aligning
simulated reads back to the C. elegans genome. I choose to simulated reads
because simulating and re-aligning reads is an incredibly useful exercise in
understanding and testing the limitations of aligners and SNP callers. I
encourage readers to try read simulation in your own organsims and projects.

See `Makefile` for a full workflow for how the BAM file `celegans.sam` and
`celegans.bam`. Both of these files are mirrored in the parent directory so
they're easier to find.

## Shuffled BAMs

Here's a quick Unixy way to shuffle a BAM file. I used this to create sample
data for this chapter, and it shows off some neat Unix tricks.

    $ (samtools view -H celegans.bam; samtools view celegans.bam | gshuf) \
        | samtools view -b - > celegans_unsorted.bam

## Exons

I grabbed the same exons from Ensemble's BioMart (XML query below):

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE Query>
    <Query  virtualSchemaName = "default" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" >
      <Dataset name = "hsapiens_gene_ensembl" interface = "default" >
        <Filter name = "ensembl_gene_id" value = "ENSG00000042781"/>
        <Attribute name = "chromosome_name" />
        <Attribute name = "exon_chrom_start" />
        <Attribute name = "exon_chrom_end" />
      </Dataset>
    </Query>

Then I dropped the first line and created a BED 3 file:

    $ sed 1d mart_export.txt > USH2A_exons.bed
