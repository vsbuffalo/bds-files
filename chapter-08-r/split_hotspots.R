# split_hotspots.R -- split the hotspot file into separate files to create data
# for this example

bedcols <- c("chr", "start", "end")
d <- read.delim("./hapmapRecombHotspots.bed", header=FALSE, col.names=bedcols)

ds <- split(d, d$chr)

lapply(names(ds), function(x)
    write.table(ds[[x]], sprintf("hotspots/hotspots_%s.bed", x), quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE))
