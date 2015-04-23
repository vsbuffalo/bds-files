import sqlite3

# the filename of this SQLite database
db_filename = "variants.db"

# initialize database connection
conn = sqlite3.connect(db_filename)

c = conn.cursor()

table_def = """\
CREATE TABLE variants(
  id integer primary key,
  chrom test,
  start integer,
  end integer,
  strand text,
  rsid text);
"""

c.execute(table_def)
conn.commit()
conn.close()

