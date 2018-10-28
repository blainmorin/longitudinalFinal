***********************
**** Final Exam *******
*** Blain Morin *******
**** 10/30/18 *********
***********************


***********************
*** Part 1 ************
***********************

* Q1

*** Import Leprosy Data
import delimited C:\Users\blain\Documents\skewl\longitudinalFinal\leprosy.csv, clear

*** Create id variable
gen id = _n

*** Make drug a factor variable
gen tx = 2 if drug == "Drug A"
replace tx = 1 if drug == "Drug B"
replace tx = 0 if drug == "Drug C"
label define tx 2 "Drug A" 1 "Drug B" 0 "Drug C"
label values tx tx

*** Reshape to long format
reshape long y, i(id) j(time)

*** Declare longitudinal
xtset id time

*** Spaghetti Plots
xtline y if tx == 2, overlay title(Trajectories for People on Drug A)

xtline y if tx == 1, overlay title(Trajectories for People on Drug B)

xtline y if tx == 0, overlay title(Trajectories for People on Drug C)

*** Boxplot by Drug
graph box y, over(time) box(1, fcolor(red)) by(tx)

*** Fit a marginal model
mixed y time i.tx c.time#i.tx || id: , noconst residuals(unstructured, t(time)) reml nolog
estimate store base

*** Add random Intercept
mixed y time i.tx c.time#i.tx || id: , residuals(unstructured, t(time)) reml nolog
estimate store ranint

*** Random intercept and Slope
mixed y time i.tx c.time#i.tx || id: time,  residuals(unstructured, t(time)) reml nolog
estimate store ranintslope

*** AIC and BIC
estimate stats base ranint ranintslope



