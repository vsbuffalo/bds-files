FASTA_FILE=http://bit.ly/egfr_flank

.PHONY: all clean

all: egfr_comp.txt

egfr_flank.fa:
	curl -L $(FASTA_FILE) > egfr_flank.fa

egfr_comp.txt: egfr_flank.fa
	seqtk comp egfr_flank.fa > egfr_comp.txt

clean:
	rm -f egfr_comp.txt egfr_flank.fa
