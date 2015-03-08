## Preface

## Regular Expression Resources

I mention these tools in the main text (and elsewhere in the Github repository)
but some great tools for writing, testing, and debugging regular expressions
are:

 - [Regular Expressions 101](https://regex101.com/)

 - [Debuggex](https://www.debuggex.com/)

## Text Editors and Terminal Setup Details

![xkcd 378](http://imgs.xkcd.com/comics/real_programmers.png)]

Personally I use both Vim and Emacs (this is my resolution to the [editor
war](http://en.wikipedia.org/wiki/Editor_war). New users usually find Emacs
easier, as it doesn't have multiple editing modes like Vim does. If you have
Emacs installed (you likely do) one of the best ways to learn is with its own
built-in tutorial. This is how I learned many years ago. You can start this
tutorial in Emacs by entering `C-h t` (that's `control-h`, release, `t`).

In addition to Vim and Emacs, other popular editors are [Sublime
Text](https://www.sublimetext.com/) and
[TextMate2](http://macromates.com/download).

Also, since I mention it in the book -- here's the [difference between a
terminal and a
shell](http://unix.stackexchange.com/questions/4126/what-is-the-exact-difference-between-a-terminal-a-shell-a-tty-and-a-con).

### Configuring Your Terminal

If you use Terminal on OS X, I highly recommend you make one change to the
settings: set the option key to meta:

![Set Terminal's option key to meta](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-00-preface/terminal-meta.png)

This will allow you to use option key to move about more easily, (e.g.
option-delete to delete an entire word, option-b to move backwards a word, and
option-f to move forwards a word).

Personally, I use the [iTerm2](http://iterm2.com/) terminal. You can set the same option there too:

![Set iTerm2's option key to meta](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-00-preface/iterm-meta.png)

See [chapter 3's
readme](https://github.com/vsbuffalo/bds-files/tree/master/chapter-03-remedial-unix#useful-unix-shortcuts)
for shortcuts to use when working with the shell.

Finally, all of my editor and shell configurations are online at
[github.com/vsbuffalo/dotfiles](https://github.com/vsbuffalo/dotfiles). You can
get a good sense of how I configure things there.

## Why Python and R?

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

## The Versions of Software I've Used

I show both the versions and how I accessed them to demonstrate how you can do
this in your own work with minimal effort. I've concatenated some of the output
to make this easier to read:

    $ samtools --version
    samtools 1.2
    Using htslib 1.2
    Copyright (C) 2015 Genome Research Ltd.

    $ bedtools --version
    bedtools v2.23.0

    $ bioawk --version
    awk version 20110810

    $ seqtk
    Version: 1.0-r75-dirty

    $ python --version
    Python 2.7.9

    $ python -c 'import pysam; print pysam.__version__'
    0.8.1

    $ make --version
    GNU Make 3.81

    $ bcftools
    Version: 1.2 (using htslib 1.2)

    $ bwa
    Program: bwa (alignment via Burrows-Wheeler transformation)
    Version: 0.7.12-r1039

    $ sqlite3 --version
    3.8.5 2014-08-15 22:37:57 c8ade949d4a2eb3bba4702a4a0e17b405e9b6ace

    $ tabix
    Version: 1.2.1

    $ bgzip
    Version: 1.2.1

    $ brew info coreutils
    coreutils: stable 8.23 (bottled), HEAD

All OS X command line utilities are the original BSD versions packaged with OS
X Yosemite.

### R `SessionInfo()`

Ok, this one's a bit ridiculous, but it works. It's the [Unix
chainsaw](http://confreaks.tv/videos/cascadiaruby2011-the-unix-chainsaw) in
action. Essentially this uses a terrific tool called
[Ag](http://betterthanack.com/) to search my book's code for anytime I've
called `library()` to load a package, turn this into a clean set of library
calls for all packages in the book, use this to load in these packages, and
then print the session info. This uses process substitution, which I teach in
Chapter 7.

    $ Rscript <((ag --nofilename -o "library\([^)]*\)" | sort | uniq | \
         grep -v "help" | grep -v "library()"); echo "print(sessionInfo())")


    R version 3.1.2 (2014-10-31)
    Platform: x86_64-apple-darwin13.4.0 (64-bit)

    locale:
    [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

    attached base packages:
    [1] stats4    parallel  methods   stats     graphics  grDevices utils
    [8] datasets  base

    other attached packages:
     [1] scales_0.2.4
     [2] qrqc_1.20.0
     [3] testthat_0.9.1
     [4] Rsamtools_1.18.3
     [5] xtable_1.7-4
     [6] brew_1.0-6
     [7] biovizBase_1.14.1
     [8] reshape_0.8.5
     [9] ggplot2_1.0.0
    [10] dplyr_0.4.1
    [11] TxDb.Mmusculus.UCSC.mm10.ensGene_3.0.0
    [12] GenomicFeatures_1.18.3
    [13] AnnotationDbi_1.28.1
    [14] Biobase_2.26.0
    [15] RSQLite_1.0.0
    [16] DBI_0.3.1
    [17] BiocInstaller_1.16.1
    [18] BSgenome.Mmusculus.UCSC.mm10_1.4.0
    [19] BSgenome_1.34.1
    [20] rtracklayer_1.26.2
    [21] Biostrings_2.34.1
    [22] XVector_0.6.0
    [23] GenomicRanges_1.18.4
    [24] GenomeInfoDb_1.2.4
    [25] IRanges_2.0.1
    [26] S4Vectors_0.4.0
    [27] BiocGenerics_0.12.1
    [28] devtools_1.7.0

    loaded via a namespace (and not attached):
     [1] acepack_1.3-3.3          assertthat_0.1           base64enc_0.1-2
     [4] BatchJobs_1.5            BBmisc_1.9               BiocParallel_1.0.3
     [7] biomaRt_2.22.0           bitops_1.0-6             checkmate_1.5.1
    [10] cluster_2.0.1            codetools_0.2-10         colorspace_1.2-4
    [13] dichromat_2.0-0          digest_0.6.8             fail_1.2
    [16] foreach_1.4.2            foreign_0.8-63           Formula_1.2-0
    [19] GenomicAlignments_1.2.2  grid_3.1.2               gtable_0.1.2
    [22] Hmisc_3.15-0             iterators_1.0.7          lattice_0.20-30
    [25] latticeExtra_0.6-26      magrittr_1.5             MASS_7.3-39
    [28] munsell_0.4.2            nnet_7.3-9               plyr_1.8.1
    [31] proto_0.3-10             RColorBrewer_1.1-2       Rcpp_0.11.4
    [34] RCurl_1.95-4.5           reshape2_1.4.1           rpart_4.1-9
    [37] sendmailR_1.2-1          splines_3.1.2            stringr_0.6.2
    [40] survival_2.38-1          tools_3.1.2              VariantAnnotation_1.12.9
    [43] XML_3.98-1.1             zlibbioc_1.12.0


