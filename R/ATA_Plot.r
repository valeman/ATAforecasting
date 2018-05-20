#' @export

plot.ata <- function(x, fcol=4, flty = 2, flwd = 2, ...)
{
	par.default <- par(no.readonly = TRUE)# save default, for resetting...
	caption <- paste(x$method,ifelse(x$model.type=="A"," Additive"," Multiplicative"), sep="")
	xx <- x$actual
	hpred <- length(x$forecast)
	freq <- frequency(xx)
	strt <- start(xx)
	xxx <- ts(c(x$actual, rep(NA,hpred)), end=tsp(xx)[2] + hpred/freq, frequency=freq)
	xxy <- ts(c(x$fitted, rep(NA,hpred)), end=tsp(xx)[2] + hpred/freq, frequency=freq)
	min_y <- min(x$actual, x$fitted, x$forecast, x$forecast.lower, na.rm=TRUE)
	max_y <- max(x$actual, x$fitted, x$forecast, x$forecast.upper, na.rm=TRUE)
	range_y <- max_y - min_y
	min_last <- min_y - range_y
	max_last <- max_y + range_y
	dataset <- cbind(xxx,xxy)
	colnames(dataset, do.NULL = FALSE)
	colnames(dataset) <- c("actual","fitted")
	tmp <- seq(from = tsp(x$forecast)[1], by = 1/freq, length = hpred)
	if (x$is.season==FALSE){
		layout(matrix(c(1, 1, 2, 3, 4, 5), 3, 2, byrow=TRUE))
		par(mar = c(bottom=1, 4.1, top=2, 1.1))
		plot(dataset,plot.type="s", ylim=c(min_last, max_last), col=1:ncol(dataset),xlab=NULL, ylab="fitted")
		polygon(x=c(tmp, rev(tmp)), y=c(x$forecast.lower, x$forecast.upper), col="lightgray", border=NA)
		lines(x$forecast, lty = flty, lwd = flwd, col = fcol)
		lines(x$out.sample, lty = 1, lwd = flwd, col = fcol+2)
		title(main=caption)
		legend("topleft", colnames(dataset), col=1:ncol(dataset), lty=1, cex=.80, box.lty=0, text.font=2, bg="transparent")
		par(mar = c(bottom=1, 4.1, top=2, 1.1))
		plot(x$level, ylab="level")
		par(mar = c(bottom=1, 4.1, top=2, 1.1))
		plot(x$trend, ylab="trend")
		par(mar = c(bottom=2, 4.1, top=2, 1.1))
		plot(x$residuals, ylab="residuals")
	}else {
		layout(matrix(c(1, 1, 2, 3, 4, 5), 3, 2, byrow=TRUE))
		par(mar = c(bottom=1, 4.1, top=2, 1.1))
		plot(dataset,plot.type="s", ylim=c(min_last, max_last), col=1:ncol(dataset), xlab=NULL, ylab="fitted")
		polygon(x=c(tmp, rev(tmp)), y=c(x$forecast.lower, x$forecast.upper), col="lightgray", border=NA)
		lines(x$forecast, lty = flty, lwd = flwd, col = fcol)
		lines(x$out.sample, lty = 1, lwd = flwd, col = fcol+2)
		title(main=paste(caption,"with Decomposition by '",ifelse(x$seasonal.model=="decomp","classical",x$seasonal.model),"' Method"))
		legend("topleft", colnames(dataset), col=1:ncol(dataset), lty=1, cex=.80, box.lty=0, text.font=2, bg="transparent")
		par(mar = c(bottom=1, 4.1, top=2, 1.1))
		plot(x$level, ylab="level")
		par(mar = c(bottom=1, 4.1, top=2, 1.1))
		plot(x$trend,ylab="trend")
		par(mar = c(bottom=2, 4.1, top=2, 1.1))
		plot(x$seasonal,ylab="seasonality")
		par(mar = c(bottom=2, 4.1, top=2, 1.1))
		plot(x$residuals, ylab="residuals")
	}
	par(par.default)
}