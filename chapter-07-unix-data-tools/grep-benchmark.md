# Grep benchmark

The data for the +grep+ benchmark figure came from:

    python  mbench.py -n 20 grep="grep AGATGCATG $FILE" \
              awk="awk '/AGATGCATG/' $FILE" \
              sed="sed -n /AGATGCATG/p  $FILE" \
              python="python search.py AGATGCATG $FILE" \
              | tee bmark.txt | column -t

where `search.py` is simply:

    import sys

    pattern = sys.argv[1]
    for line in open(sys.argv[2]):
        line = line.strip()
        if pattern in line:
            print line

I've included the `bmark.txt` file in this directory.
