import re
import sys
from readfq import readfq

complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A', 'N':'N'}

if len(sys.argv) < 3:
    sys.exit("error: too few arguments\nusage: find_motif.py infile.fa <motifseq>\n")

seqs = dict()
infile = open(sys.argv[1])
for name, seq, qual in readfq(infile):
    seqs[name] = seq

motif_str = sys.argv[2].upper()
motif_str_rc = "".join([complement[b] for b in motif_str[::-1]])
pat = "(%s|%s)" % (motif_str.replace("N", "[ATCG]"), motif_str_rc.replace("N", "[ATCG]"))
motif = re.compile(pat, flags=re.IGNORECASE)

for name, seq in seqs.items():
    matches = motif.finditer(seq)
    for match in matches:
        if match is not None:
            if len(sys.argv) == 4:
                print "\t".join(map(str, (name, match.start(), match.end(), sys.argv[3])))
            else:
                print "\t".join(map(str, (name, match.start(), match.end())))
            #print "\t".join(map(str, (name, match.start(), match.end(), seq[match.start():match.end()])))
