# plots.R -- plots for the chapter (grey scale and themeless)
library(ggplot2)
library(gridExtra)

# This is where to save the plots for the book.
#
# If you're a reader trying to recreate my plots, change this to a directory and
# prefix you want the images saved to. And yes this is an absolute link ;-) (see ch2)
BOOKDIR <- "~/Dropbox/bioinfo_data_skills/images/ch08/ggplot-"

gsave <- function(x, name, ...) {
  ggsave(paste0(BOOKDIR, name, ".png"), x, ...)
  cat(sprintf('[[ch08-ggplot-%s]]
.
image::images/ch08/ggplot-%s.png[float="true"]\n', name, name))
}

theme <- theme_bw() + theme(plot.background = element_blank(),
                            #panel.grid.minor = element_blank(),
                            #panel.grid.major = element_blank(),
                            axis.line = element_line(color = 'black'))

d <- read.csv("Dataset_S1.txt")
colnames(d)[12] <- "percent.GC"
d$cent <- d$start >= 25800000 & d$end <= 29700000
d$diversity <- d$Pi / (10*1000)


d$position <- (d$end + d$start) / 2
p <- ggplot(d) + geom_point(aes(x=position, y=diversity)) + theme
gsave(p, "scatter-01")

p <- ggplot(d) + geom_point(aes(x=position, y=diversity, color=cent)) + theme +   scale_color_grey()
gsave(p, "scatter-02")


p <- ggplot(d) + geom_point(aes(x=position, y=diversity), alpha=0.01) + theme + scale_color_grey()
gsave(p, "scatter-03")

p <- ggplot(d) + geom_density(aes(x=diversity), fill="black") + theme
gsave(p, "density-01")


p <- ggplot(d) + geom_density(aes(x=diversity, fill=cent), alpha=0.4) + theme + scale_fill_grey() 
gsave(p, "density-02")

p <- ggplot(d, aes(x=depth, y=total.SNPs)) + geom_point() + geom_smooth(color="grey") + theme
gsave(p, "smooth-01")

p <- ggplot(d, aes(x=percent.GC, y=depth)) + geom_point() + geom_smooth(color="grey") + theme
gsave(p, "smooth-02")

d$GC.binned <- cut(d$percent.GC, 5)
p <- ggplot(d) + geom_density(aes(x=depth, linetype=GC.binned), alpha=0.5) + theme
gsave(p, "gc-01")

#p <- ggplot(d) + geom_bar(aes(x=GC.binned)) + theme + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
p <- ggplot(d) + geom_bar(aes(x=GC.binned)) + theme + theme(axis.text.x=element_text(size=5.5))
q <- ggplot(d) + geom_bar(aes(x=percent.GC)) + theme+ theme(axis.text.x=element_text(size=8))
r <- arrangeGrob(p, q, nrow=1)
r
gsave(r, "gc-02", width=6, height=4)


## motif example
mtfs <- read.delim("motif_recombrates.txt", header=TRUE)
rpts <- read.delim("motif_repeats.txt", header=TRUE)
mtfs$pos <- paste(mtfs$chr, mtfs$motif_start, sep="-")
rpts$pos <- paste(rpts$chr, rpts$motif_start, sep="-")
mtfs$repeat_name <- rpts$name[match(mtfs$pos, rpts$pos)]

p <- ggplot(mtfs, aes(x=dist, y=recom)) + geom_point(size=1, color="grey") + geom_smooth(method='loess', se=FALSE, span=1/10) +theme
gsave(p, "mtfs-01")


p <- ggplot(mtfs, aes(x=dist, y=recom)) + geom_point(size=1, color="grey") + geom_smooth(method='loess', se=FALSE, span=1/10) + facet_wrap(~ motif) + theme
gsave(p, "mtfs-02")


p <- ggplot(mtfs, aes(x=dist, y=recom)) + geom_point(size=1, color="grey") + geom_smooth(method='loess', se=FALSE, span=1/16) + facet_grid(repeat_name ~ motif) + theme
gsave(p, "mtfs-03")


p <- ggplot(mtfs, aes(x=dist, y=recom)) + geom_point(size=1, color="grey") + geom_smooth(method='loess', se=FALSE, span=1/16) + facet_wrap( ~ motif, scales="free_y") + theme
gsave(p, "mtfs-04")



