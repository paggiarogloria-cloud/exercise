cd "C:\Users\vento\Desktop\Empirical Political Economy"

*data cleaning
order loc, first
order fyear, after(loc)

sort loc fyear
drop if capx==.
drop if cogs==.
drop if sale==.
drop if capx<=0
drop if cogs<=0
drop if sale<=0
tab loc fyear
drop if loc == "BFA"
drop if loc == "BFA" 
drop if loc == "BRB" 
drop if loc == "BWA" 
drop if loc == "CAN" 
drop if loc == "CIV" 
drop if loc == "ECU" 
drop if loc == "FLK" 
drop if loc == "FRO" 
drop if loc == "GAB" 
drop if loc == "GGY" 
drop if loc == "GHA" 
drop if loc == "GIB" 
drop if loc == "GRL" 
drop if loc == "GUF" 
drop if loc == "IMN" 
drop if loc == "KGZ"
drop if loc == "KHM" 
drop if loc == "LBN" 
drop if loc == "LBR" 
drop if loc == "LIE" 
drop if loc == "MAC" 
drop if loc == "MCO" 
drop if loc == "MOZ" 
drop if loc == "MWI" 
drop if loc == "NAM" 
drop if loc == "TAN" 
drop if loc == "PNG" 
drop if loc == "PSE" 
drop if loc == "REU" 
drop if loc == "SDN" 
drop if loc == "SEN" 
drop if loc == "SLB" 
drop if loc == "SRB"
drop if loc == "SVK" 
drop if loc == "TCA" 
drop if loc == "TTO" 
drop if loc == "TZA" 
drop if loc == "UGA" 
drop if loc == "VEN" 
drop if loc == "VGB" 
drop if loc == "VIR" 
drop if loc == "WSM" 
drop if loc == "ZMB"

drop if loc=="CZE"
drop if loc=="PAN"
drop if loc=="MKD"
drop if loc=="MLT"
drop if loc=="MNG"

*generating aggrgate markup
gen firmyearelasticity=cogs/(cogs+capx)

drop median_elasticity
egen median_elasticity=median(firmyearelasticity), by(gsector loc)
gen firmyearmarkup1=sale/cogs
gen firmyearmarkup=median_elasticity*firmyearmarkup1

egen total_sale=total(sale), by(loc fyear)
gen marketshare=sale/total_sale
gen markup=marketshare*firmyearmarkup

egen aggregatemarkup=total(markup), by(loc fyear)

winsor aggregatemarkup, gen(markup) p(0.05) highonly
*gen log as well

save dati.dta 

duplicates drop aggregatemarkup, force

drop if loc=="BMU"
drop if loc=="CYM"
drop if loc=="JEY"

* data merging
sort loc year
cd "C:\Users\vento\Desktop\Empirical Political Economy"
merge 1:1 loc year using "datiridotti.dta"

* il prof ha detto è inutile
keep if year==1990| year==1995| year ==2000| year ==2005| year==2010| year==2015 | year==2022
(1,825 observations deleted)

egen nrcountry=group(country)

egen nryear=group(year)

sort nrcountry nryear

tab(year), gen(yr)
xtset nrcountry yr
xtreg electoral_democracy L.electoral_democracy L.Aggregatemarkup yr*, fe vce(robust)

*baseline model 
gen v_demlag=F5.v_dem
xtset country year 
xtreg v_demlag v_dem markup i.year, fe robust

xtreg v_dem l1.v_dem l1.markup i.year, fe robust
xtreg v_dem l10.v_dem l10.markup i.year, fe robust

*alternative dataset 
rename v2x_libdem liberal_democracy
gen liberal_democracylag=F5.liberal_democracy
xtreg liberal_democracylag liberal_democracy markup i.year, fe robust
rename v2x_partipdem participatory_democracy
gen participatory_democracylag=f5.liberal_democracylag
xtreg participatory_democracylag participatory_democracy markup i.year,fe robust
rename v2x_delibdem deliberative_democracy
gen deliberative_democracylag=f5.deliberative_democracy
xtreg deliberative_democracylag deliberative_democracy markup i.year, fe robust
rename v2x_egaldem egalitarian_democracy
gen egalitarian_democracylag=f5.egalitarian_democracy
xtreg egalitarian_democracylag egalitarian_democracy markup i.year, fe robust

*to save
outreg2 using dem, word dec(3) drop(i.year)  ctitle() addstat("F-Stat",e(F), "Prob>F", e(p)) addtext (Country FE, YES, Year FE, YES) append/replace








 
 

