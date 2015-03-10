# Git for Scientists

## A Note about Git GUIs

This whole chapter uses command line Git. I've sort of hidden the fact from
readers that there are several useful Git GUIs you could also use. I
intentionally only teach command-line Git in the book because (1) I think this
the best way to first learn Git, even if use the GUI later on and (2) readers
at this point shouldn't be scared of the command line. However, if you do want
to use a GUI (and using a Git GUI is certainly better than not using Git at
all!), here are some:

 - [GitHub Mac](https://mac.github.com/) (OS X). Is Github's client made to
   work well with repositories on Github. There's also a [Windows
version](https://windows.github.com/).

 - [SourceTree](http://www.sourcetreeapp.com/) (Windows, OS X). Very nice interface.

 - [Git-cola](https://git-cola.github.io/) (Windows, OS X, Linux)

## Commit Messages

Commit messages are rather important, but other folks have noticed
that it is annoying to write them as a project drags on:

![xkcd 1296](http://imgs.xkcd.com/comics/git_commit.png)

[xkcd 1296](http://xkcd.com/1296/)

## Undoing Commits

One way to "undo" commits is with `git revert`. `git revert` doesn't truly undo
commits though, it just adds a new commit on top of the past commit. See
[Atlassian's
tutorial](https://www.atlassian.com/git/tutorials/undoing-changes/git-revert)
for a good explanation of the distinction.

Truly undoing a commit requires advanced `git reset`, which *could* lead to
data loss (if you're not careful). See:

 - [How to undo the last commit](http://stackoverflow.com/questions/927358/how-to-undo-the-last-commit) on StackOverflow.

 - [Atlassian's tutorial on git reset](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset)

## Github Flow

Git is a versatile version control system; there are many workflows you and
your collaborators can adopt that would work well. Usually the variety of
different workflows is overwhelming, and some do work better than others. These
days, one of the most popular is _Github Flow_. Github flow works really well
with projects hosted on Github, as it's based around collaborators developing
on branches in their own repositories, and others pulling these commits into
the master branch of the project. The simplest introduction to Github Flow is
[Understanding Github Flow](https://guides.github.com/introduction/flow/).

