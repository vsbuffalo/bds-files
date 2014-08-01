# Resources for Chapter 7 -- Unix Data Tools

Bentley's *Programming Pearls* column with Donald Knuth and Doug McIlroy is
available on the [ACM website](http://dl.acm.org/citation.cfm?id=5948.315654).
One particularly excellent quote from McIlroy that I didn't include is:

> Knuth has shown us here how to program intelligibly, but not wisely. I buy
> the discipline. I do not buy the result. He has fashioned a sort of
> industrial-strength Fabergé egg -- intricate, wonderfully worked, refined
> beyond all ordinary desires, a museum piece from the start.


grep "^#" -v Mus_musculus.GRCm38.75_chr1.gtf | awk '{if ($3=="gene" && $2 == "protein_coding") { print $0 }}' | cut -f 9 | sed 's/; / /g' | sed 's/ / /g' | cut -f2,4 | sed 's/"//g' > Mus_musculus.GRCm38.75_chr1_genes.txt

wc -l Mus_musculus.GRCm38.75_chr1_genes.txt

verify in martview http://uswest.ensembl.org/biomart/martview/ == same number

contam.fastq -- shorter version (used in book so examples print more clearly)
