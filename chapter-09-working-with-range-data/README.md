# Ranges Chapter Supplementary Material

## Files

- `mm10_ensGene_chr1.gtf.gz` was downloaded from the UCSC Genome Browser's
  Table Browser (http://genome.ucsc.edu/cgi-bin/hgTables). This was file was
downloaded on 2014-08-01.

- `Mus_musculus.GRCm38.75_chr1.gtf.gf` are chromosome 1 annotations extracted
  from `Mus_musculus.GRCm38.75.gtf.gz` downloaded from Ensembl's FTP
(ftp://ftp.ensembl.org/pub/release-75/gtf/mus_musculus) on 2014-08-02.

        gzcat Mus_musculus.GRCm38.75.gtf.gz | egrep "^(1\t|#)" | gzip > Mus_musculus.GRCm38.75_chr1.gtf.gf

- `mm10_snp137_chr1.bed.gz` was downloaded from the UCSC Genome Browser's Table
  Browser (http://genome.ucsc.edu/cgi-bin/hgTables). This was file was
downloaded on 2014-08-01.


