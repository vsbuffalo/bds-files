import sys
import gzip
from collections import OrderedDict
import sqlite3
import pdb

pops = "EAS SAS AFR EUR AMR".split()
pop_freqs = [p + "_AF" for p in pops]

cols = "CHROM POS RSID REF ALT QUAL FILTER INFO FORMAT".lower().split()

db_filename = sys.argv[1]
db_tablename = sys.argv[2]
vcf_filename = sys.argv[3]

reader = gzip.open if vcf_filename.endswith('.gz') else open

TBL_COLS = ["chrom", "pos", "rsid", "ref", "alt"] + [s.lower() for s in pop_freqs]
TBL_TYPES = ["text", "integer", "text", "text", "text"] + ["text"] * len(pop_freqs)
TBL = OrderedDict(zip(TBL_COLS, TBL_TYPES))
TBL_TYPESTR = ",\n".join(["%s %s" % (k, v) for k, v in TBL.items()])

conn = sqlite3.connect(db_filename)
conn.text_factory = str
c = conn.cursor()
TBL_SCHEMA = "CREATE TABLE %s(\nid integer PRIMARY KEY NOT NULL,\n%s)" % (db_tablename, TBL_TYPESTR)
c.execute(TBL_SCHEMA)

for line in reader(vcf_filename):
    if line.startswith("#"):
        continue
    fields = line.strip().split("\t")
    fields = dict(zip(cols, fields[:len(cols)]))
    if not fields['rsid'].startswith('rs'):
        continue

    # parse INFO block, extract pop freqs
    info_chunks = [x.partition('=') for x in fields['info'].split(';')]
    info = dict([(k, v) for k, _, v in info_chunks])
    for pop_freq in pop_freqs:
        fields[pop_freq.lower()] = info[pop_freq]

    # insert into table
    placeholders = ["?"] * len(TBL_COLS)
    query = "INSERT INTO %s (%s) VALUES (%s);" % (db_tablename, ", ".join(TBL_COLS), ", ".join(placeholders))
    c.execute(query, [fields[k] for k in TBL_COLS])

conn.commit() # commit these inserts
c = conn.cursor()

