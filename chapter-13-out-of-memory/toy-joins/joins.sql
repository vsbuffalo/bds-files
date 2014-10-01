CREATE TABLE assocs(
  id integer primary key,
  study_id integer,
  trait text,
  strongest_risk_snp text);

CREATE TABLE studies(
  id integer primary key,
  pubmedid integer,
  year integer,
  journal text);

.separator "\t"
.import assocs.txt assocs
.import studies.txt studies
