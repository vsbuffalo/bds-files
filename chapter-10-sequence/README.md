# Chapter 10: Sequence Data

The example FASTA file was downloaded from the Ensembl biomart interface. This
example file contains the upstream flanking regions (only 60bp, so the example
prints in the book) for the human FOXP2 gene. The biomart query in XML format
is:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Query>
<Query  virtualSchemaName = "default" formatter = "FASTA" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" >
  <Dataset name = "hsapiens_gene_ensembl" interface = "default" >
    <Filter name = "upstream_flank" value = "60"/>
    <Filter name = "ensembl_gene_id" value = "ENSG00000128573"/>
    <Attribute name = "ensembl_gene_id" />
    <Attribute name = "ensembl_transcript_id" />
    <Attribute name = "transcript_flank" />
  </Dataset>
</Query>
```
