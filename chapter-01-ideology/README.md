# Ideology: Data Skills, Robust and Reproducible Bioinformatics

Below are some supplementary material to this chapter -- mostly additional
resources.

## On the Way I Cover Reproducibility

I simplify "reproducibility" in this chapter, intentionally. Earlier versions
tried to discuss differences between reproducibility, replicability,
portability, etc. because these differences do matter. But my primary goal is
to move 80% of readers to be 40% more reproducible. Covering all of these
differences in depth usually loses readers, and might only make 10% of readers
80% more reproducible. If I had to list my hierarchy of reproducibility wishes,
it would be something like:

1. Scientists should release their data
2. Scientists should release their code.
3. Scientists should record all software versions and command line arguments
   *exactly*.
4. Scientists should write code that doesn't rely on hard-coded absolute paths,
   as this makes following work hard. Relative paths or command line arguments
(with the command line run) are better alternatives. Hard-coded but clearly
documented options at the top of script are acceptable.
5. Scientists should explicitly test that their scripts are portable or user a
   container system like [Docker](https://www.docker.com/).

## More Information on Reproducibility

A great introduction to intermediate and advanced reproducibility tools is
[rOpenSci's](http://ropensci.org/) [Reproducibility
Guide](http://ropensci.github.io/reproducibility-guide/). I also really like
Roger Peng's article [Reproducible Research in Computational Science
](http://www.sciencemag.org/content/334/6060/1226.abstract) (though this is
sadly behind a paywall). Karl Broman also teaches a stellar course on
reproducibility, with [fully open access notes and course
materials](http://kbroman.org/Tools4RR/).

Projects like [iPython Notebook](http://ipython.org/notebook.html) and R's
[knitr](http://www.amazon.com/exec/obidos/ASIN/1482203537/7210-20) have really
changed the reproducibility tools modern computational researchers use in their
work. I cover knitr in the R chapter (chapter 8), but only briefly; I highly
encourage the reader to spend more time learning knitr and using it in their
work.

## More Information on Unit Testing

I introduce unit testing in this chapter, but don't go into much detail
throughout the book about this. This is both because the book is already quite
long, and I think it can be difficult for readers to learn unit testing
alongside the material in the book. However, unit testing is important (hence,
why I introduce it) and the curious reader should learn more. I suggest:

 - [Testing Your Code](http://docs.python-guide.org/en/latest/writing/tests/)
   in the terrific [The Hitchhiker's Guide to
Python](http://docs.python-guide.org/en/latest/)

 - [Beautiful
   Testing](http://www.amazon.com/Beautiful-Testing-Professionals-Software-Practice/dp/0596159811)
by O'Reilly and Goucher.

 - Hadley Wickham's [testthat](https://github.com/hadley/testthat) package for R, and [his corresponding article](http://journal.r-project.org/archive/2011-1/RJournal_2011-1_Wickham.pdf) in the R Journal.

 - [Python's DocTests](https://docs.python.org/2/library/doctest.html)

 - [Nose](https://nose.readthedocs.org/en/latest/) is a particularly nice and
   popular testing framework for Python.

## Documentation

I don't discuss tools like [iPython Notebook](http://ipython.org/notebook.html)
or [knitr](http://yihui.name/knitr/) in depth in my book due to space
limitations (though I introduce them and highly encourage their use). These
tools are also quite easy to learn on your own. To help get you started, here
are some resources:

 - iPython Notebook's [introduction](http://ipython.org/ipython-doc/stable/interactive/tutorial.html).

 - iPython Notebook [video and screencasts](http://ipython.org/videos.html)

 - [Karl Broman's](https://twitter.com/kwbroman) terrific [knitr in a
   nutshell](http://kbroman.org/knitr_knutshell/)

 - [knitr's documentation](http://yihui.name/knitr/)

 - knitr's creator Yihui Xie's book, [Dynamic Documents with R and
   knitr](http://www.amazon.com/dp/1482203537/ref=cm_sw_su_dp)

## More information on the "Duke Saga"

There's a lot bioinformaticians can learn from the Duke Saga. It's a useful
event to study for the same reasons a airplane crash is useful; we can learn a
lot from catastrophic failures. Here are some more resources:

 - Read their original article, *[Deriving chemosensitivity from cell lines:
   Forensic bioinformatics and reproducible research in high-throughput
biology](http://projecteuclid.org/euclid.aoas/1267453942)*

 - See [CBS 60 Minutes piece on the saga](https://www.youtube.com/watch?v=66dPIFMJ_-A)

 - See [Baggerly's talk on this
   work](http://videolectures.net/cancerbioinformatics2010_baggerly_irrh/). [Slides](http://bioinformatics.mdanderson.org/Supplements/ReproRsch-All/Modified/StarterSet/baggerly_nebraska12.pdf).

## Tukey's Quote

Tukey's quote comes from this note, *The Technical Tools of Statistics* (1964):
ftp://cm.bell-labs.com/cm/stat/tukey/memo/techtools.html
