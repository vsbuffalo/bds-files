# Code Examples

This directory contains the Python code for the examples at the end of Chapter
13. This code doesn't explicitly handle missing values, but this is a fairly
simple change. Basically, in the list compression:

    coerced_values = [tbl_cols[col](value) for col, value in cols_values]

We need to replace `tbl_cols[col](value)` with a function that checks input for
missing values. A quick implementation may look something like:

    def clean_input(col, val, na_strings=['na']):
        val = val.strip()
        if len(val) == 0 or val.lower() in [s.lower() for s in na_strings]:
            return None
        try:
            val = tbl_cols[col](val) # uses global column types set
        except ValueError:
            return None # coercion valued, also missing

We must be really careful how to handle missing values. To be robust, I've both
handled them explicitly through the `na_strings` and through `try`/`catch`. I'd
argue both are necessary for robust code, though *there are reasons you might
not want to catch this exception* (e.g. if you expect input to be either
coercible or an NA string). Regarding the `try`/`catch` remember: Python is a
[EAFP](https://docs.python.org/2/glossary.html#term-eafp) language, not a
[LBYL](https://docs.python.org/2/glossary.html#term-lbyl) language. This is
another reason Python is a truly wonderful language.
