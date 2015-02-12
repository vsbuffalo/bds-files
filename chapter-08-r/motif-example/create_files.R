# create_files.R -- create file for example
#
# Note: this is definitely a quick approximation. The purpose of this is
# primarily to show how few lines of code it can take to replicate a major
# finding (if this isn't a good reason to learn bioinformatics, I don't know
# what is). It's entirely possible there's an off-by-one error do to coordinate
# system switches (but on data at this scale, this will not affect anything).

library(GenomicRanges)
library(ggplot2)

bedcols <- c("chr", "start", "end")

# load in motifs
mtfs <- with(read.delim("data/motifs.bed", header=FALSE,
                        col.names=c(bedcols, "name")),
             GRanges(chr, IRanges(start, end), strand="+", name=name))

# load recombination rates
recomb <- with(read.delim("data/hapmapRecombRate.bed", header=FALSE,
                          col.names=c(bedcols, "recomb")), 
               GRanges(chr, IRanges(start, end), strand="+", recomb=recomb))

# load in repeats
repeats <- with(read.delim("data/hotspot_repeats.bed", header=FALSE,
                     col.names=c(bedcols, "name")),
          GRanges(chr, IRanges(start, end), strand="+", name=name))

# for each motif, find all recombination windows within 40kb and save columns:
# motifs, chrom, position, dist to motif, motif name
size <- 40e3
mtfs_win <- resize(mtfs, width=2*size, fix="center")

mwino <- findOverlaps(mtfs_win, recomb, ignore.strand=TRUE)

mid <- function(x) (start(x) + end(x))/2

# reate the dataframe of all motifs, their corresponding recomb windows withing 40kb
# and the recomb rates (plus other info):
d <- do.call(rbind, lapply(split(as.data.frame(mwino), queryHits(mwino)),
              function(x) {
                  m <- mtfs[x[, 1]]
                  r <- recomb[x[, 2]]
                  data.frame(chr=seqnames(m),
                             motif_start=start(m),
                             motif_end=end(m),
                             dist=mid(m) - mid(r),
                             recomb_start=start(r),
                             recomb_end=end(r),
                             recom=r$recomb,
                             motif=m$name)
              }))

# Now create a dataframe of overlapping repeats
hits <- findOverlaps(mtfs, repeats, type="within")
repeats_containing_motifs <- repeats[subjectHits(hits), ]
repeats_containing_motifs$motif_start <- start(mtfs)[queryHits(hits)]

rcm <- as.data.frame(repeats_containing_motifs)
colnames(rcm)[1] <- "chr"
rcm <- rcm[, setdiff(colnames(rcm), c("width", "strand"))]
rcm <- rcm[rcm$motif_start %in% d$motif_start, ] # simplify example

# constrain distance (some weirdness due to way overlaps are calculated is possible)
d <- d[abs(d$dist) <= 40e3, ]

## Save results (to chapter parent directory)
write.table(d, file="../motif_recombrates.txt", sep="\t",
            quote=FALSE, row.names=FALSE)

write.table(rcm, file="../motif_repeats.txt", sep="\t", quote=FALSE,
            row.names=FALSE)

## Here are the merge steps covered in the text
# merge using match
# first, we build a column that will work as a key.
d$pos <- paste(d$chr, d$motif_start, sep="-")
rcm$pos <- paste(rcm$chr, rcm$motif_start, sep="-")
table(d$pos %in% rcm$pos)

i <- match(d$pos, rcm$pos)
j <- na.exclude(i)
dm <- cbind(d[!is.na(i), ], rcm[j, ])

# merge
ds <- merge(d, rcm, by.x = c("chr", "motif_start"),
           by.y = c("chr", "motif_start"))













