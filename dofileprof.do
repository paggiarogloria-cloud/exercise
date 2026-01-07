*baseline model
xtset country year 
xtreg v_demlag v_dem markup i.year, fe robust

*alternative lags
xtreg v_dem l1.v_dem l1.markup i.year, fe robust
xtreg v_dem l10.v_dem l10.markup i.year, fe robust

*alternative democracy indexes
xtreg liberal_democracylag liberal_democracy markup i.year, fe robust
xtreg participatory_democracylag participatory_democracy markup i.year,fe robust
xtreg deliberative_democracylag deliberative_democracy markup i.year, fe robust
xtreg egalitarian_democracylag egalitarian_democracy markup i.year, fe robust

