import sqlite3
import sys
import os
import gzip
from collections import OrderedDict

GWASCAT_COLS = ("dbdate", "pubmedid", "author", "date", "journal", "link",
"study", "trait", "initial_samplesize", "replication_samplesize", "region",
"chrom", "position", "reported_genes", "mapped_gene", "upstream_gene_id",
"downstream_gene_id", "snp_gene_ids", "upstream_gene_distance",
"downstream_gene_distance", "strongest_snp_risk_allele", "snps", "merged",
"snp_id_current", "context", "intergenic", "risk_allele_freq", "pvalue",
"pvalue_mlog", "pvalue_text", "or_beta", "ci_95", "platform", "cnv")

GWASCAT_TYPES = ("text", "integer", "text", "text", "text", "text",
"text", "text", "text", "text", "text",
"text", "integer", "text", "text", "text",
"text", "text", "integer", "integer",
"text", "text", "integer", "text",
"text", "integer", "real", "real", "text",
"real", "real", "text", "text", "text")

## We're going to split the snp risk allele into risk_snp, risk_allele (better for joins)
TBL_COLS = list(GWASCAT_COLS)
TBL_TYPES = list(GWASCAT_TYPES)
pos = TBL_COLS.index("strongest_snp_risk_allele")
TBL_COLS.insert(pos+1, "strongest_risk_allele")
TBL_COLS[pos] = "strongest_risk_snp"
TBL_TYPES.insert(pos+1, "text")

# mapping between columns to keep and their SQLite types
TBL = OrderedDict(zip(TBL_COLS, TBL_TYPES))

db_filename = sys.argv[1]
db_tablename = sys.argv[2]
gwas_filename = sys.argv[3]

reader = gzip.open if gwas_filename.endswith('.gz') else open

TBL = OrderedDict(zip(TBL_COLS, TBL_TYPES))
TBL_TYPESTR = ",\n".join(["%s %s" % (k, v) for k, v in TBL.items()])

## SQLite to Python types (for checking, exception handling)
TYPES = {"text":str, "integer":int, "real":float}

def cleanfield(x):
    """
    Simple cleaning function: if field is 'NR' or '', make None (in SQLite this
    is NULL), otherwise, strip field.
    """
    if x is None:
        return x
    x = x.strip()
    if x.upper() in ("-", "NONE", "NA", "NR") or len(x) == 0:
        return None
    return x


conn = sqlite3.connect(db_filename)
conn.text_factory = str
c = conn.cursor()
TBL_SCHEMA = "CREATE TABLE %s(\nid integer PRIMARY KEY NOT NULL,\n%s)" % (db_tablename, TBL_TYPESTR)
c.execute(TBL_SCHEMA)

header = True
for line in reader(gwas_filename):
    if header:
        header = False
        continue

    fields = line.strip().split("\t")
    # try to coerce field type, if fails makes NULL
    coerced_fields = list()
    # parse all fields, getting appropriate conversion function fron TYPES,
    # if conversion fails, convert to NULL. If the column is strongest_snp_risk_allele,
    # split into snp and allele.
    for field, col, ftype in zip(fields, GWASCAT_COLS, GWASCAT_TYPES):
        if ftype is None:
            continue # this type not loaded in table
        if col == "strongest_snp_risk_allele":
            snp, _, allele = field.partition("-")
            allele = None if allele.upper() not in "ACTG" else allele.upper().strip()
            #import pdb; pdb.set_trace()
            coerced_fields.extend((snp.strip(), allele))
            continue
        if col in ("dbdate", "date"):
            month, day, year = field.split('/')
            # into ISO 8601
            coerced_fields.append("%s-%s-%s" % (year, month, day))
            continue
        try:
            typefun = TYPES.get(ftype, None)
            if typefun is not None:
                cfield = cleanfield(field)
                if cfield is None:
                    coerced_fields.append(None)
                else:
                    # coerce only if not None
                    coerced_fields.append(typefun(cfield))
            else:
                coerced_fields.append(cleanfield(field))
        except:
            coerced_fields.append(None)

    # insert into table
    placeholders = ["?"] * len(TBL_COLS)
    query = "INSERT INTO %s (%s) VALUES (%s);" % (db_tablename, ", ".join(TBL_COLS), ", ".join(placeholders))
    c.execute(query, coerced_fields)

conn.commit() # commit these inserts
c = conn.cursor()

