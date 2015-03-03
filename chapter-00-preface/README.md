## Preface

### Regular Expression Resources

I mention these tools in the main text (and elsewhere in the Github repository)
but some great tools for writing, testing, and debugging regular expressions
are:

 - [Regular Expressions 101](https://regex101.com/)

 - [Debuggex](https://www.debuggex.com/)

### Text Editors and Setup Details

Personally I use Vim and Emacs. New users usually find Emacs easier, as it
doesn't have multiple editing modes like Vim does. If you have Emacs installed
(you likely do) one of the best ways to learn is with its own built-in
tutorial. This is how I learned many years ago. You can start this tutorial in
Emacs by entering `C-h t` (that's `control-h`, release, `t`).

### Why Python and R?

I've chosen to teach bioinformatics data skills in this book with Python and R
as the primary analysis languages, with a good dose of Unix command line tools.
As you mature as a bioinformatician, you may choose different languages that
suit you better. In the meantime, let me explain why I chose Python and R.

It may seem strange that I went with Python given bioinformatics has a long
history with Perl, but there are good reasons. First, Python is rapidly
increasing in popularity in bioinformatics, thanks to excellent
community-supported libraries. Many new bioinformatics tools and libraries are
being written exclusively in Python.

Second, I think the Python language is particularly appropriate for beginning
scientific coders. I find that Python's clear, pseudocode-like syntax is easy
for new coders to understand and its philosophy is congruent with this book's
goal of robust and reproducible analysis. This philosophy can be read in
[http://www.python.org/dev/peps/pep-0020/](The Zen of Python), but some core
ideas are:

 - Explicit is better than implicit.
 - Simple is better than complex.
 - Readability counts.
 - Errors should never pass silently.
 - There should be one —and preferably only one— obvious way to do it.

In Chapter 2, you'll see how these concepts foster reproducible and robust
code. While an experienced coder can write explicit, simple, readable code in
Perl, I find it's harder and more time consuming for a beginning to reach this
level. Perl's philosophy of "There's more than one way to do it" and more
complex syntax can also make the learning curve for beginners a bit steeper.
Reproducible and robust bioinformatics analysis can be tricky enough as it is,
so I prefer the clarity, power, and simplicity of Python.

My choice to use R is less controversial than choosing Python over Perl. R is
the most popular open source statistical language and has a large, growing
community and vast repository of contributed packages. In Chapter 9 I will
introduce Bioconductor, the project and repository for R bioinformatics
software. Many bioinformatics articles that implement novel statistical methods
include an accompanying Bioconductor or R package, making both essential parts
of bioinformatics analysis.

### The Version of Software I've Used
