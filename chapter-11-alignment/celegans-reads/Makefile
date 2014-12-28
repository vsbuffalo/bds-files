ZCAT=gzcat # change if not on OS X to zcatjj

all: celegans.bam

Caenorhabditis_elegans.WBcel235.dna.toplevel.fa:
	curl ftp://ftp.ensembl.org/pub/release-77/fasta/caenorhabditis_elegans/dna/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa.gz | $(ZCAT) > $@

celegans-full-1.fq celegans-full-2.fq celegans-wgsim.out: Caenorhabditis_elegans.WBcel235.dna.toplevel.fa
	wgsim -S 23 -1 50 -2 50 $^ celegans-full-1.fq celegans-full-2.fq > celegans-wgsim.out

celegans.bam: celegans-full-1.fq celegans-full-2.fq Caenorhabditis_elegans.WBcel235.dna.toplevel.fa
	seqtk sample -2 -s 23 celegans-full-1.fq 100 > celegans-1.fq
	seqtk sample -2 -s 23 celegans-full-2.fq 100 > celegans-2.fq
	bwa index Caenorhabditis_elegans.WBcel235.dna.toplevel.fa
	# align reads, giving example read group ID
	bwa mem -R "@RG\tID:VB00023_L001\tSM:celegans-01" Caenorhabditis_elegans.WBcel235.dna.toplevel.fa celegans-1.fq celegans-2.fq > celegans.sam
	samtools view -b celegans.sam > celegans.bam

clean:
	rm -f celegans-1.fq celegans-1.fq celegans-full-1.fq celegans-full-2.fq celegans.bam celegans.sam

