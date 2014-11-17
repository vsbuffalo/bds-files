import sys
import sqlite3
from collections import OrderedDict

# the filename of this SQLite database
db_filename = "variants.db"

# initialize database connection
conn = sqlite3.connect(db_filename)
c = conn.cursor()

## Load Data
# columns (other than id, which is automatically incremented
tbl_cols = OrderedDict([("chrom", str), ("start", int),
                        ("end", int), ("strand", str),
                        ("rsid", str)])

def record_generator(input_file):
    """
    A generator that returns lists of coerced values, from the columns of
    input_file.
    """
    for line in input_file:
        # split a tab-delimited line
        values = line.strip().split("\t")

        # pair each value with it's column name
        cols_values = zip(tbl_cols.keys(), values)

        # use the column name to lookup an appropriate function to coerce each
        # value to the appropriate type
        coerced_values = [tbl_cols[col](value) for col, value in cols_values]
        yield coerced_values

## Create the query
# create an empty list of placeholders
placeholders = ["?"] * len(tbl_cols)
colnames = ", ".join(tbl_cols.keys())
placeholders = ", ".join(placeholders)
query = "INSERT INTO variants(%s) VALUES (%s);" % (colnames, placeholders)

# Create a generator to parse input file and load into database
input_file = open(sys.argv[1])
records = record_generator(input_file)
c.executemany(query, records)
conn.commit()
conn.close()


