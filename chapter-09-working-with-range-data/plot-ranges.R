# plot-ranges.R -- a function for plotting IRanges data
# Copyright (C) 2014 Vince Buffalo <vsbuffaloAAAAA@gmail.com>
# Distributed under terms of the BSD license.

covdf <- function(cov) {
	# from example in IRanges vignette
	cov <- as.vector(cov)
	mat <- cbind(seq_along(cov)-0.5, cov)
	d <- diff(cov) != 0
	mat <- rbind(cbind(mat[d,1]+1, mat[d,2]), mat)
	mat <- mat[order(mat[,1]),]
	data.frame(pos=mat[, 1], cov=mat[, 2])
}

plotIRanges <- function(..., sep=0.5, height=1, set_breaks=TRUE, labcol="grey",
												names=NULL, cov=FALSE, clear=FALSE, disjoint=NULL,
												color=NULL) {
	if (!is.null(colors)) stopifnot(length(colors) <= 3L)
	COLORS <- c("white", "#383838", "#DDDDDD")
	x <- list(...)
	if (!is.null(names))
		names(x) <- names
	dl <- lapply(x, function(d) {
							 out <- as.data.frame(d)
							 out$y <- disjointBins(d)
							 out
							})
	d <- do.call(rbind, dl)
	if (!is.null(disjoint))
		# manually assigned bins
		d$y <- disjoint
	d$ymin <- d$y * (sep + height) - height
	d$ymax <- d$ymin + height
	if (!is.null(color))
		d$color <- color
	if (length(x) > 1 && is.null(names(x)))
		stop("multiple ranges must be given names like plotRanges(rng1=y, rng2=x)")
	if (length(x) > 1)
		d$range <- factor(rep(names(x), sapply(x, length)), names(x))
	p <- ggplot(d)
	if (clear)
		p <- p + geom_rect(aes(ymin=ymin, ymax=ymax, xmin=start-0.5, xmax=end+0.5),
											 fill="white", color="grey30", size=0.3)
	else if(is.null(color))
		p <- p + geom_rect(aes(ymin=ymin, ymax=ymax, xmin=start-0.5, xmax=end+0.5))
	else {
		p <- p + geom_rect(aes(ymin=ymin, ymax=ymax, xmin=start-0.5,
													 xmax=end+0.5, fill=color), color="grey30", size=0.3)
		p <- p + scale_fill_manual("", guide=FALSE,
															 values=COLORS[1:length(unique(color))])
	}
	p <- p + theme_bw()
	if (!is.null(d$names)) {
		p <- p + geom_text(aes(x=start + width/2 - 0.5,
													 y=ymin+(ymax-ymin)/2, label=names), size=8, color=labcol)
	}
	xmin <- min(d$start)
	xmax <- max(d$end)
	xbreaks <- seq(xmin - 1L, xmax + 1L)
	if (set_breaks)
		p <- p + scale_x_continuous(breaks=xbreaks)
	p <- p + theme(panel.grid.major=element_blank(),
								 panel.grid.minor.y=element_blank(),
								 axis.ticks=element_blank())
	if (!cov)
		p <- p + theme(axis.text.y=element_blank())
	p <- p + xlab("") + ylab("")
	if (length(unique(d$range)) > 1)
		p <- p + facet_wrap(~ range, ncol=1)
	if (cov)
		p <- p + geom_line(aes(x=pos, y=cov), covdf(coverage(rngs)), color="red", size=3)
	p
}



