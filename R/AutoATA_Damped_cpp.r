#' @export AutoATA.Damped

AutoATA.Damped <- function(ts_input, pb, qb, model.Type, accuracy.Type, level.fix, trend.fix, phiStart, phiEnd, phiSize, initialLevel, initialTrend, orig_X, Holdout, HoldoutSet, Adjusted_P)
{
	Xdata <- as.numeric(ts_input)
	TA_0 <- Xdata-ATA.Shift(Xdata,1)
	TM_0 <- Xdata/ATA.Shift(Xdata,1)
	model.Type <- ifelse(is.null(model.Type),"B",model.Type)
	if (Holdout==TRUE){
		output <- AutoATADampedHoldout(as.double(Xdata)
							, as.integer(ifelse(pb=="opt", -1, pb))
							, as.integer(ifelse(qb=="opt", -1, qb))
							, as.integer(switch(model.Type,"B"=0,"A"=1,"M"=2))
							, as.integer(switch(accuracy.Type,"MAE"=1,"MdAE"=2,"MSE"=3,"MdSE"=4,"MPE"=5,"MdPE"=6,"MAPE"=7,"MdAPE"=8,"sMAPE"=9,"sMdAPE"=10,"RMSE"=11,"MASE"=12,"OWA"=13))
							, as.integer(ifelse(level.fix, 1, 0))
							, as.integer(ifelse(trend.fix, 1, 0))
							, as.double(phiStart)
							, as.double(phiEnd)
							, as.double(phiSize)
							, as.integer(ifelse(initialLevel, 1, 0))
							, as.integer(ifelse(initialTrend, 1, 0))
							, as.double(TA_0)
							, as.double(TM_0)
							, as.integer(frequency(ts_input))
							, as.double(HoldoutSet))	
	}else {
		output <- AutoATADamped(as.double(Xdata)
						, as.integer(ifelse(pb=="opt", -1, pb))
						, as.integer(ifelse(qb=="opt", -1, qb))
						, as.integer(switch(model.Type,"B"=0,"A"=1,"M"=2))
						, as.integer(switch(accuracy.Type,"MAE"=1,"MdAE"=2,"MSE"=3,"MdSE"=4,"MPE"=5,"MdPE"=6,"MAPE"=7,"MdAPE"=8,"sMAPE"=9,"sMdAPE"=10,"RMSE"=11,"MASE"=12,"OWA"=13))
						, as.integer(ifelse(level.fix, 1, 0))
						, as.integer(ifelse(trend.fix, 1, 0))
						, as.double(phiStart)
						, as.double(phiEnd)
						, as.double(phiSize)
						, as.integer(ifelse(initialLevel, 1, 0))
						, as.integer(ifelse(initialTrend, 1, 0))
						, as.double(TA_0)
						, as.double(TM_0)
						, as.integer(frequency(ts_input)))
	}
	ifelse(Holdout==TRUE & Adjusted_P==TRUE, new_pk <- round((output[1] * length(orig_X))/ length(ts_input)), new_pk <- output[1])
	ATA.last <- ATA.Core(orig_X, pk = new_pk, qk = output[2], phik = output[3], mdlType = ifelse(output[4]==1,"A","M"), initialLevel = initialLevel, initialTrend = initialTrend)
	ATA.last$holdout <- Holdout	
	if(Holdout==TRUE){
		ATA.last$holdout.accuracy <- output[5]
		ATA.last$holdout.forecast <- ATAHoldoutForecast(as.double(Xdata)
														, as.integer(output[1])
														, as.integer(output[2])
														, as.integer(output[3])
														, as.integer(output[4])
														, as.integer(switch(accuracy.Type,"MAE"=1,"MdAE"=2,"MSE"=3,"MdSE"=4,"MPE"=5,"MdPE"=6,"MAPE"=7,"MdAPE"=8,"sMAPE"=9,"sMdAPE"=10,"RMSE"=11,"MASE"=12,"OWA"=13))
														, as.integer(ifelse(initialLevel, 1, 0))
														, as.integer(ifelse(initialTrend, 1, 0))
														, as.double(TA_0)
														, as.double(TM_0)
														, as.integer(frequency(ts_input))
														, as.double(HoldoutSet))
	}
	return(ATA.last)
}