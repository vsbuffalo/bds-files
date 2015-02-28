#!/usr/bin/env python
# nuccount.py -- tally nucleotides in a file
import sys
from collections import Counter
from readfq import readfq

IUPAC_BASES = "ACGTRYSWKMBDHVN-."

# intialize counter
counts = Counter()

for name, seq, qual in readfq(sys.stdin):
    # for each sequence entry, add all its bases to the counter
    counts.update(seq.upper())

# print the results
for base in IUPAC_BASES:
    print base + "\t" + str(counts[base])
