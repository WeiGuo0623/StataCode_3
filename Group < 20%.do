/* Program Description */
/* OLS */
clear
import delimited using "data_0715.csv", delimiter(",")
rename ï date
rename commonstoc~l SharesTotal
rename v18 SharesTotal2
rename v16 closelyheld2
rename priceclose PriceClose
rename totalasset~d TAsset
rename roatotalas~t ROA
rename returnoneq~l ROE
rename bookvaluep~e BookValue
rename totalliabi~s Liability
rename pedailytim~o PE
rename commonshar~y SEquity
rename ebitmargin~t EBITmargin
rename intangible~s RD

gen CHSptc = closelyheld/SharesTotal
order CHSptc, after(closelyheld)

gen CHSptc_inst2 = closelyheld2/SharesTotal2
order CHSptc_inst2, after(CHSptc)

gen DEA = Liability/TAsset

gen TQ_num = (PriceClose*SharesTotal)+(TAsset-SEquity)
gen TQ_den = (BookValue*SharesTotal)+(TAsset-SEquity)
gen TQ = TQ_num/TQ_den

drop TQ_num TQ_den SharesTotal TAsset Liability SEquity BookValue PriceClose closelyhel~s v17 closelyheld2 SharesTotal2 data

centile CHSptc, centile(5,10,20,40,60,80)

/* TQ > 5% & TQ < 20% */

gen X2 = CHSptc
keep if X2 > 0.05 & X2 <= 0.2

ivreg TQ ROA PE EBITmargin RD DEA (CHSptc = CHSptc_inst2)
reg CHSptc CHSptc_inst2

/* Hausman test */
quietly ivreg TQ ROA PE EBITmargin RD DEA (CHSptc = CHSptc_inst2)
est store IV_reg
quietly regress TQ CHSptc ROA PE EBITmargin RD DEA
est store LS_reg
hausman IV_reg LS_reg


