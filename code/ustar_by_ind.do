
/*
This file replicates u* by Industry
Code by: Camilla Adams in Feb 2023
*/

global raw "/Users/camillaadams/Dropbox/ustar_by_ind/raw"
global inter "/Users/camillaadams/Dropbox/ustar_by_ind/intermediate"
global graphs "/Users/camillaadams/Dropbox/Mac/Documents/ustar_by_ind/exhibits/graphs"
global tables "/Users/camillaadams/Dropbox/Mac/Documents/ustar_by_ind/exhibits/tables"

global cps "/Users/camillaadams/Dropbox/ustar_by_ind/raw/cps"
global archive "/Users/camillaadams/Dropbox/Mac/Documents/slack/archive"
global code "/Users/camillaadams/Dropbox/Mac/Documents/ustar_by_ind/code"

local cps_data 1
local recession_data 1
local NES_data 1
local unemp_rate 1
local number_of_vacancies 1
local number_of_employees 1
local moredetailed_emp 1
local number_of_unemployed 1
local estimate_beveridge_curve 1 
local estimate_breaks 1
local estimate_efficient_unemp 1
local estimating_work_from_home_break 1
local cps_transition_matrix 1
local rc_table 1
local run_all 1


global fontsize "size(medium)"
global xlabel "xlabel(,labsize(medlarge))"
global ylabel "ylabel(, labsize(medlarge))"

global yellow = "237 193 91"
global orange = "217 106 60"
global pink = "217 72 112"
global purple = "113 71 219"
global blue = "90 134 239"
global green = "67 151 42"


***************************** CPS *********************************************

if `cps_data' == 1 | `run_all' == 1 {

import delimited "$raw/ind_to_naics.csv", clear 
*keep if naics_digit == 2

gen cat = ""
replace cat = "ag" if naics == 11
replace cat = "mine" if naics == 21
replace cat = "cons" if naics == 23
replace cat = "manu" if naics == 31 | naics == 32 | naics == 33
replace cat = "trade" if naics == 42 | naics == 44 | naics == 45
replace cat = "tu" if naics == 48 | naics == 49 | naics == 22
replace cat = "info" if naics == 51
replace cat = "finan" if naics == 52 | naics == 53
replace cat = "pbs" if naics == 54 | naics == 55 | naics == 56 
replace cat = "ehs" if naics == 61 | naics == 62 | naics == 56 
replace cat = "lah" if naics == 71 | naics == 72 
replace cat = "other" if naics == 81
replace cat = "govt" if naics == 92

duplicates drop ind, force

save "$inter/naics_ind_crosswalk", replace


use "$cps/cps_00015.dta", clear	 
keep if year>=2014 & year<=2019

keep if empstat == 21 | empstat ==22 | empstat == 10 | empstat == 12 // looking at employed and unemployed

drop if ind == 9890 // drop people whose most recent job was in US military, but no long in military and are unemployed

merge m:1 ind using "$inter/naics_ind_crosswalk"


*https://cps.ipums.org/cps/codes/ind_2014_codes.shtml
replace cat = "ag" if ind == 170 | ind ==180 // agriculture
replace cat = "govt" if inlist(ind, 9370, 9380, 9390, 9470, 9480, 9490, 9570, 9590) // government
replace cat = "govt" if ind == 6370 // postal service
replace cat = "other" if ind ==9290  // private hh
replace cat = "tu" if ind ==6080 | ind == 590 // rail transportation, natural gas

assert cat != "" if empstat != 22 // new workers don't have unemployment rates

keep if cat != "" 
keep ind1990 naics cat

gen counter = 1
collapse (sum) counter, by(ind1990 cat) // bad choice
duplicates t ind1990, gen(x)
cap drop k
bysort ind1990: gen k = _n
by ind1990: keep if k == _N
save "$inter/naics_ind1990_crosswalk", replace 



use "$cps/cps_00015.dta", clear	 
keep if empstat==21 | empstat == 22
drop if ind == 9890 // armed services
merge m:1 ind1990 using "$inter/naics_ind1990_crosswalk"

drop if occ1950 == 595 // armed services
tab ind if empstat == 21 & _merge !=3

keep if cat != ""
tabulate cat, generate(cat)

drop if cat1 == 1
drop cat1


collapse (mean) cat2 cat3 cat4 cat5 cat6 cat7 cat8 cat9 cat10 cat11 cat12 cat13 [aweight = wtfinl], by(year month)

egen sanity_check = rowtotal(cat2-cat13)


rename cat2 unemp_p_cons
rename cat3 unemp_p_ehs
rename cat4 unemp_p_finan
rename cat5 unemp_p_govt
rename cat6 unemp_p_info
rename cat7 unemp_p_lah
rename cat8 unemp_p_manu
rename cat9 unemp_p_mine
rename cat10 unemp_p_other
rename cat11 unemp_p_pbs
rename cat12 unemp_p_trade
rename cat13 unemp_p_tu

drop if year == .
drop sanity_check

save "$inter/percent_unemp_by_ind", replace


}

*************************** RECESSION DATA *************************************

if `recession_data' == 1 | `run_all' == 1 {

/*
Import quarterly recession indicators 
*/

import fred USRECQ, clear

gen yq = qofd(daten)
format yq %tq
drop datestr daten
rename yq qdate
save "$inter/recession_data", replace

}

*************************** NATIONAL EMPLOYER SURVEY ***************************

if `NES_data' == 1 | `run_all' == 1 {

/* Import National Employer Survey (NES) provided by Pascal. Calculate percent of 
time spent recruiting by industry. */

use "$raw/nes.dta", clear

*** Create indicators for each industry
*manu 
gen ind_1 = 0
replace ind_1 = 1 if  man ==1 

* construction 
gen ind_2 = 0
replace ind_2 = 1 if ind11 == 1

* health services 
gen ind_3 = 0
replace ind_3 = 1 if ind21 == 1

* finance (finance and insurance)
gen ind_4 = 0
replace ind_4 = 1 if ind17 ==1 | ind18 == 1

* lah (hotels)
gen ind_5 = 0
replace ind_5 = 1 if ind19 == 1

* pbs (business services)
gen ind_6 = 0
replace ind_6 = 1 if ind20 == 1

* trade 
gen ind_7 = 0
replace ind_7 =1 if ind15==1 // wholesale
replace ind_7 =1 if ind16==1 // retail

* trans/utilities 
gen ind_8 = 0
replace ind_8 = 1 if ind14 == 1 // utilities
replace ind_8 = 1 if ind12 == 1 // transportation services

*** Create cateogrical variable for each industry
gen ind_cat = .
replace ind_cat = 1 if ind_1 == 1
replace ind_cat = 2 if ind_2 == 1
replace ind_cat = 3 if ind_3 == 1
replace ind_cat = 4 if ind_4 == 1
replace ind_cat = 5 if ind_5 == 1
replace ind_cat = 6 if ind_6 == 1
replace ind_cat = 7 if ind_7 == 1
replace ind_cat = 8 if ind_8 == 1


* identify number of firms by industry
preserve
gen counter = 1
collapse (sum) counter, by(ind_cat)
drop if ind_cat == .

 
gen industry_name = "Manufacturing" if ind_cat == 1
replace industry_name = "Construction" if ind_cat == 2
replace industry_name = "Edu/Health" if ind_cat == 3
replace industry_name = "Finance" if ind_cat == 4
replace industry_name = "Leisure/Accom" if ind_cat == 5
replace industry_name = "Prof/Business" if ind_cat == 6
replace industry_name = "Trade" if ind_cat == 7
replace industry_name = "Trans/Utilities" if ind_cat == 8

save "$inter/number_of_firms", replace
restore

* idenitfy mean recruiting expenditure by industry
collapse (mean) q29, by(ind_cat)

drop if ind_cat == .

gen x = 1

reshape wide q29, i(x) j(ind_cat)

rename q291 rc_manu
rename q292 rc_cons
rename q293 rc_ehs
rename q294 rc_finan
rename q295 rc_lah
rename q296 rc_pbs
rename q297 rc_trade
rename q298 rc_tu
gen rc_all = 3.2

drop x

save "$inter/cost_of_recruiting", replace


}


****************************** UNEMPLOYMENT RATE *******************************

if `unemp_rate' == 1 | `run_all' == 1 {

* Data comes from Table 14-A
* https://fred.stlouisfed.org/release/tables?rid=50&eid=4635#snid=4685 (NOT SEASONALLY ADJUSTED)
import excel "$raw/list_of_unemployment_variables.xls", sheet("Monthly") firstrow clear

* drop unemployment levels (only want unemployment rates)
drop LNU03*

foreach x of varlist LNU04028615-UNRATENSA {
	import fred `x', clear
	save "$raw/unemp_rates/`x'", replace
}

* import all unemployment rates from FRED API
local sheetnames : dir "$raw/unemp_rates/" files "*.dta"
local exclude "LNU04028615"
local sheetnames : list sheetnames - exclude

use "$raw/unemp_rates/LNU04028615.dta", clear

foreach sheet of local sheetnames {
    merge 1:1 daten using "$raw/unemp_rates/`sheet'"
    drop _merge
}

rename LNU04032232 unemp_manu
rename LNU04032231 unemp_cons
rename LNU04032240 unemp_ehs
rename LNU04032238 unemp_finan
rename LNU04028615 unemp_govt
rename LNU04032237 unemp_info
rename LNU04032241  unemp_lah
rename LNU04032230 unemp_mine
rename LNU04032239 unemp_pbs
rename LNU04032242 unemp_other
rename LNU04032235 unemp_trade
rename LNU04032236 unemp_tu

* save merged non-seasonally adjusted unemployment rates
save "$inter/industry_unemployment_notsa", replace

* run seasonal adjustment (seasonal adjustment performed in R)
do "$code/seasonal adjustment.do"

* turn into stata dta files
local ind manu cons ehs finan govt info lah mine pbs other tu trade
foreach x of local ind {
	import delimited "$inter/sa/unemp_sa/unemp_`x'.csv", clear
	rename unemp unemp_`x'
	lab var unemp_`x' "unemployment rate for `x', Seasonally Adjusted"
	save "$inter/sa/unemp_sa/unemp_`x'", replace
}

* merge stata data files
use "$inter/sa/unemp_sa/unemp_manu", clear

local ind  cons ehs finan govt info lah mine pbs other tu trade
foreach x of local ind {
	merge 1:1 date using "$inter/sa/unemp_sa/unemp_`x'", nogen
}


gen daten = date(date, "YMD")
format daten %td

order daten
save "$inter/industry_unemployment", replace


}


****************************** NUMBER OF VACANCIES *****************************
*https://fred.stlouisfed.org/release/tables?rid=192&eid=6679

if `number_of_vacancies' == 1 | `run_all' == 1 {


import excel "$raw/vacancycountnotsa.xls", sheet("Monthly") firstrow clear

foreach x of varlist JTU00MWJOL-JTUJOL {
	import fred `x', clear
	save "$raw/num_vac/`x'", replace
}




* import all unemployment rates from FRED API
local sheetnames : dir "$raw/num_vac/" files "*.dta"
local exclude "JTU00MWJOL"
local sheetnames : list sheetnames - exclude


use "$raw/num_vac/JTU00MWJOL", clear
foreach sheet of local sheetnames {
    merge 1:1 daten using "$raw/num_vac/`sheet'"
    drop _merge
}


gen jo_trade = JTU4200JOL + JTU4400JOL // wholesale + retail trade
gen jo_tu = JTU4000JOL - jo_trade // TTU - trade = trans and utilities
rename JTU3000JOL jo_manu
rename JTU2300JOL jo_cons
rename JTU6000JOL jo_ehs
rename JTU510099JOL jo_finan
rename JTU9000JOL jo_govt
rename JTU5100JOL jo_info
rename JTU7000JOL  jo_lah
rename JTU110099JOL jo_mine
rename JTU540099JOL jo_pbs
rename JTU8100JOL jo_other
rename JTU4000JOL jo_ttu

drop JTU00MWJOL JTU00NEJOL JTU00SOJOL JTU00WEJOL JTU1000JOL JTU3200JOL JTU3400JOL JTU4200JOL JTU4400JOL ///
JTU5200JOL JTU5300JOL JTU6100JOL JTU6200JOL JTU7100JOL JTU7200JOL JTU9100JOL JTU9200JOL JTUJOL

save "$inter/industry_vacancy_notsa", replace


do "$code/seasonal adjustment.do"


local ind manu cons ehs finan govt info lah mine pbs other tu trade
foreach x of local ind {
	import delimited "$inter/sa/vac_sa/jo_`x'.csv", clear
	rename jo jo_`x'
	lab var jo_`x' "job openings for `x', Seasonally Adjusted"
	save "$inter/sa/vac_sa/jo_`x'", replace
}

use "$inter/sa/vac_sa/jo_manu", clear

local ind  cons ehs finan govt info lah mine pbs other tu trade
foreach x of local ind {
	merge 1:1 date using "$inter/sa/vac_sa/jo_`x'", nogen
}


gen daten = date(date, "YMD")
format daten %td

order daten
save "$inter/industry_vacancy", replace

}

************************ NUMBER OF EMPLOYEES BY INDUSTRY ***********************
* https://fred.stlouisfed.org/release/tables?rid=50&eid=4881#snid=4882 (starts as seasonally adjusted)

if `number_of_employees' == 1 | `run_all' == 1 {

*** import variable names from FRED tables
import excel "$raw/number_of_employees.xls", sheet("Monthly") firstrow clear

*** import from FRED 
foreach x of varlist CES0800000001-USTPU {
	import fred `x', clear
	save "$raw/`x'", replace
}


import fred USTRADE, clear
save "$raw/USTRADE", replace

import fred USWTRADE, clear
save "$raw/USWTRADE", replace

*** merge all time series
use "$raw/CES0800000001", clear

local number_of_employees MANEMP USCONS USEHS USFIRE USGOOD USGOVT USINFO USLAH USMINE USPBS USSERV USTPU USTRADE USWTRADE
foreach x of local number_of_employees {
	merge 1:1 daten using "$raw/`x'", nogen keep(3)
}

rename USTRADE emp_retail
rename USWTRADE emp_whole 
gen emp_trade = emp_retail + emp_whole
rename MANEMP emp_manu
rename USCONS emp_cons
rename USEHS emp_ehs
rename USFIRE emp_finan
rename USGOVT emp_govt
rename USINFO emp_info
rename USLAH  emp_lah
rename USMINE emp_mine
rename USPBS emp_pbs
rename USSERV emp_other
rename USTPU emp_ttu

gen emp_tu = emp_ttu - emp_trade // Trans, Trade, Utilities - Trade = TU

drop CES0800000001 USGOOD

lab var emp_trade "All Employees, Trade (Wholesale + Retail)" 
lab var emp_tu "All Employees, Transportation and Utilities" 



save "$inter/industry_employment", replace
}



************************ NUMBER UNEMPLOYED BY INDUSTRY ***********************

if `number_of_unemployed' == 1 | `run_all' == 1 {

* UEMPLT5 // less than 5 weeks
* UEMP5TO14 // 5-14
* UEMP15OV // 15 and over

local unemptotals UEMPLT5 UEMP5TO14 UEMP15OV

foreach x of local unemptotals {
	import fred `x', clear
	save "$raw/`x'", replace
}

use "$raw/UEMPLT5", clear
merge 1:1 daten using "$raw/UEMP5TO14", nogen
merge 1:1 daten using "$raw/UEMP15OV", nogen

gen year = year(daten)
drop if year<2000

gen number_of_unemp = UEMPLT5 + UEMP5TO14 + UEMP15OV

gen month = month(daten)
save "$inter/number_of_unemployed", replace


merge 1:1 year month using "$inter/percent_unemp_by_ind"

local ind manu cons ehs finan govt info lah mine pbs other trade tu
foreach x of local ind {
	gen unemp_number_`x' = number_of_unemp*unemp_p_`x'
}

drop month year

egen total_check = rowtotal(unemp_number_manu unemp_number_cons unemp_number_ehs unemp_number_finan unemp_number_govt unemp_number_info unemp_number_lah unemp_number_mine unemp_number_pbs unemp_number_other unemp_number_trade unemp_number_tu)

save "$inter/industry_number_of_unemployed", replace
}




if `estimate_beveridge_curve' == 1 | `run_all' == 1 {

* combine fred data
use "$inter/industry_vacancy", clear
merge 1:1 daten using "$inter/industry_employment", nogen keep(3)
merge 1:1 daten using "$inter/industry_unemployment", nogen keep(3)
merge 1:1 daten using "$inter/industry_number_of_unemployed", nogen keep(3)

* year labels
gen month = month(daten)
gen year = year(daten)
gen year_lab = substr(datestr,1,4) if month == 1
replace year_lab = "2020m3" if year == 2020 & month == 3
gen ym = ym(year, month)
format ym %tm

* log vacancy rate and log unemployment rate
local ind manu cons ehs finan govt info lah mine pbs other trade tu
foreach x of local ind {
	gen vac_`x' = (jo_`x'/(emp_`x' + unemp_number_`x'))*100
	gen log_vacrate_`x' = ln((jo_`x'/(emp_`x' + unemp_number_`x'))*100)
	gen log_unemp_`x' = ln(unemp_`x')
}

* calculate aggregate unemployment and vacancy rates
egen jo_all = rowtotal(jo_*)
egen unemp_number_all = rowtotal(unemp_number_*)
egen emp_all = rowtotal(emp_*)

gen vac_all = (jo_all/(emp_all + unemp_number_all))*100
gen log_vacrate_all = ln((jo_all/(emp_all + unemp_number_all))*100)

gen unemp_all = unemp_number_all/(emp_all + unemp_number_all)*100
gen log_unemp_all = ln(unemp_all)

line unemp_all year

* Monthly Beveridge Curve Inputs
save "$inter/bev_curve_data", replace

*************************************

* Collapse to Quarterly Level Beveridge Data
gen qdate = qofd(dofm(ym(year, month)))
format %tq qdate

collapse (mean) log_vacrate_* log_unemp_* unemp_* vac_* emp_*, by(qdate)

egen total_emp = rowtotal(emp_*)

local ind manu cons ehs finan govt info lah mine pbs other trade tu
foreach x of local ind {
	gen percent_emp_`x' = emp_`x'/total_emp
}

cap drop year
gen year = yofd(dofq(qdate))
extrdate quarter  quarter = qdate

gen year_lab = year if quarter ==1
tostring year_lab, replace
replace year_lab = "" if year_lab == "."


* graph aggregate unemployment and vacancy rate
twoway line unemp_all qdate,  ytitle("Unemployment Rate") lcolor("$orange") lwidth(medthick) || line vac_all qdate, yaxis(2) ytitle("Vacancy Rate", axis(2)) lcolor("$blue") lwidth(medthick) xtitle("Quarter") legend(label(1 "Unemployment Rate") label(2 "Vacancy Rate") pos(6) cols(2))
graph export "$graphs/unemp_vac.png", replace

line vac_all qdate


save "$inter/bev_curve_data_quarterly", replace

}







********************** ESTIMATING BREAKS ***********************

if `estimate_breaks' == 1 | `run_all' == 1 {

use "$inter/bev_curve_data_quarterly", clear

tsset qdate
sort qdate

local ind manu cons ehs finan govt info lah mine pbs other tu trade all
foreach x of local ind {
	
	xtbreak estimate log_vacrate_`x' log_unemp_`x', breaks(2) trim(0.10) breakconstant
	estat indicator breaks_`x'

	gen elas_`x' = .

		forval i=1/3 {
			reg log_vacrate_`x' log_unemp_`x' if breaks_`x' == 	`i'
			replace elas_`x' = _b[log_unemp_`x'] if breaks_`x' == 	`i'
			}
	replace elas_`x' = abs(elas_`x' )

}

save "$inter/elasticity_breaks_allyrs", replace





use "$inter/elasticity_breaks_allyrs", clear


generate string_date = string(qdate, "%tq")


local ind manu cons ehs finan govt info lah mine pbs other trade tu all
foreach x of local ind {

gen switch_`x' = .
replace switch_`x' = 1 if breaks_`x'[_n-1] != breaks_`x'[_n] 
replace switch_`x' = 1 if switch_`x'[_n+1] == 1
replace switch_`x' = 1 if switch_`x'[_n] == _N
replace switch_`x' = 1 if _n == _N


gen string_switch_`x' = string_date if switch_`x' == 1

}


local ind manu cons ehs finan govt info lah mine pbs other trade tu all
foreach x of local ind {

	gen cum_`x' = sum(switch_`x')

	* indicate switches
	forval i = 1/2 {
	
		if `i' == 1 {
			local a 2
			local b 3
		}
	
		if `i' == 2 {
			local a 4
			local b 5
		}
	
		gen connecters_vac_`x'_`i' = .
		gen connecters_unemp_`x'_`i' = .

		replace connecters_vac_`x'_`i' = log_vacrate_`x' if switch_`x' == 1 & (cum_`x' == `a' | cum_`x' == `b')
		replace connecters_unemp_`x'_`i' = log_unemp_`x' if switch_`x' == 1 & (cum_`x' == `a' | cum_`x' == `b')
	
		replace connecters_vac_`x'_`i' = . if _n == 1
		replace connecters_vac_`x'_`i' = . if _n == _N
	
		replace connecters_unemp_`x'_`i' = . if _n == 1
		replace connecters_unemp_`x'_`i' = . if _n == _N 
	}
}


local lwidth thin
local mpostition mlabposition(9)

** Create beveridge curves with breaks
local ind manu cons ehs finan govt info lah mine pbs other trade tu all
foreach x of local ind {

gen ll_`x' =.
gen ul_`x' =. 
	

reg log_vacrate_`x' log_unemp_`x' if breaks_`x' == 1
local x1: display %5.2f -1*_b[log_unemp_`x']
local cons1: display %5.2f _b[_cons]
di "`x1'"
matlist r(table) 
local ll = r(table)[5,1]
local ul = r(table)[6,1]

replace ll_`x' = abs(`ll') if breaks_`x' == 1
replace ul_`x' = abs(`ul') if breaks_`x'  == 1


reg log_vacrate_`x' log_unemp_`x' if breaks_`x' == 2
local x2: display %5.2f -1*_b[log_unemp_`x']
local cons2: display %5.2f _b[_cons]
matlist r(table) 
local ll = r(table)[5,1]
local ul = r(table)[6,1]

replace ll_`x' = abs(`ll') if breaks_`x'  == 2
replace ul_`x' = abs(`ul') if breaks_`x'  == 2


reg log_vacrate_`x' log_unemp_`x' if breaks_`x' == 3
local x3: display %5.2f -1*_b[log_unemp_`x']
local cons3: display %5.2f _b[_cons]

matlist r(table) 
local ll = r(table)[5,1]
local ul = r(table)[6,1]

replace ll_`x' = abs(`ll') if breaks_`x'  == 3
replace ul_`x' = abs(`ul') if breaks_`x' == 3

twoway  ///
scatter log_vacrate_`x' log_unemp_`x' if breaks_`x' == 1, connect(daten) msymbol(i)  mlabel(string_switch_`x') lwidth(`lwidth') lcolor("$pink") mlabcolor("$pink") `mpostition' || ///
scatter log_vacrate_`x' log_unemp_`x' if breaks_`x' == 2, connect(daten) msymbol(i)  mlabel(string_switch_`x') lwidth(`lwidth') lcolor("$purple") mlabcolor("$purple" ) `mpostition' || ///
scatter log_vacrate_`x' log_unemp_`x' if breaks_`x' == 3, connect(daten) msymbol(i)  mlabel(string_switch_`x') lwidth(`lwidth') lcolor("$blue") mlabcolor("$blue" ) `mpostition' || ///
lfit log_vacrate_`x' log_unemp_`x' if breaks_`x' == 1,  lcolor("$pink") lwidth(vthin) || ///
 lfit log_vacrate_`x' log_unemp_`x' if breaks_`x' == 2,  lcolor("$purple")  lwidth(vthin)  || ///
 lfit log_vacrate_`x' log_unemp_`x' if breaks_`x' == 3,  lcolor("$blue")  lwidth(vthin)  || ///
 scatter connecters_vac_`x'_1 connecters_unemp_`x'_1, connect(daten) msymbol(i) lcolor("180 179 180") lpattern(dash_dot) lwidth(thin) || ///
  scatter connecters_vac_`x'_2 connecters_unemp_`x'_2, connect(daten) msymbol(i) lcolor("180 179 180") lpattern(dash_dot) lwidth(thin) ///
 note("Elasticity: Period 1: `x1', Period 2: `x2', Period 3: `x3'" "Constants: Period 1: `cons1', Period 2: `cons2', Period 3: `cons3'") ytitle("log(Vacancy Rate)") xtitle("log(Unemployment Rate)") $xlabel $ylabel legend(off)
graph export "$graphs/bev_withbreaks_`x'.png", replace
}

save "$inter/breaks_with_ul_ll", replace




*** combine breaks over all time and post 2012 break
use "$inter/breaks_with_ul_ll", clear

global ylabel "ylabel(, labsize(medlarge))"

merge m:1 qdate using "$inter/recession_data", nogen keep(3)

replace USRECQ = USRECQ*1.75

*** graph breaks
local ind manu cons ehs finan govt info lah mine pbs other trade tu
foreach x of local ind {
	tsset qdate 
	twoway (area USRECQ qdate, color(gs14)) (rarea ul_`x' ll_`x' qdate, color("194 189 206")) (line elas_`x' qdate, lwidth(medthick) lcolor("$purple")) , ytitle("Mean Elasticity", $fontsize) xtitle("Year, Month", $fontsize)  $xlabel yscale(range(0 1.75))  ylabel(0(.25)1.75, labsize(medlarge)) /*tline(2020q1, lcolor(red)) *//*legend(label(1 "US Recession") label(2 "95% conf. interval") label(3 "Point Estimate of Elasticity") pos(6) col(3))*/ legend(off)
	graph export "$graphs/elas_break_`x'.png", replace
} // industry loop

}





********************** ESTIMATING EFFICIENT UNEMPLOYMENT ***********************

if `estimate_efficient_unemp' == 1 | `run_all' == 1 {

use "$inter/breaks_with_ul_ll", clear
gen x = 1

merge m:1 x using  "$inter/cost_of_recruiting", nogen assert(3)

local ind manu cons ehs finan lah pbs trade tu all
foreach x of local ind {
gen kappa_`x' = (rc_`x'*(1-(unemp_`x'/100)))/vac_`x'
}


local ind manu cons ehs finan lah pbs trade tu all 
foreach x of local ind {
	gen u_star_`x'_breaks = (((kappa_`x'*elas_`x')/(1-0.26)) * (vac_`x'/unemp_`x'^(-elas_`x')) )^(1/(1+elas_`x'))
}



local ind manu cons ehs finan lah pbs trade tu all 
foreach x of local ind {
	
gen breaks_indc_`x' = 1 if breaks_`x'[_n] != breaks_`x'[_n-1]
replace breaks_indc_`x' = . if _n ==1


gen cum_break = sum(breaks_indc_`x') 
replace breaks_indc_`x' = 2 if cum_break == 2 & breaks_indc_`x' ==1

cap drop cum_break
}


local ind manu cons ehs finan lah pbs tu trade all
foreach x of local ind {
	gen unemp_gap_`x' =  unemp_`x' - u_star_`x'
}

global labfont "labsize(medium)"


local ind manu cons ehs finan lah pbs trade tu all
local r = 1
foreach x of local ind {
	
sum unemp_gap_`x'
local mean_unemp_gap: display %5.2f r(mean)	
	
sum unemp_gap_`x' if year<= 2019
local mean_unemp_gap19: display %5.2f r(mean)		
	
	if `r' == 1 { // manu
		local yax "yscale(r(0 15)) ylab(0(5)15, $labfont)"
		local xlab "xlab(, $labfont)"
		local k = 15
	}
	
	if `r' == 2 { // cons
		local yax "yscale(r(0 25)) ylab(0(5)25, $labfont)"
		local xlab "xlab(, $labfont)"		
		local k = 25
	}
	
	if `r' == 3 { // ehs
		local yax "yscale(r(0 15)) ylab(0(5)15, $labfont)"
		local xlab "xlab(, $labfont)"		
		local k = 15
	}
		
	if `r' == 4 { // finan
		local yax "yscale(r(0 10)) ylab(0(5)10, $labfont)"
		local xlab "xlab(, $labfont)"		
		local k = 10
	}
		
	if `r' == 5 { // lah
		local yax "yscale(r(0 40)) ylab(0(10)40, $labfont)"
		local xlab "xlab(, $labfont)"		
		local k = 40
	}	
	if `r' == 6 { //pbs
		local yax "yscale(r(0 15)) ylab(0(5)15, $labfont)"
		local xlab "xlab(, $labfont)"		
		local k = 15
	}
	
	if `r' == 7 { //pbs
		local yax "yscale(r(0 15)) ylab(0(5)15, $labfont)"
		local xlab "xlab(, $labfont)"		
		local k = 15
	}
	
	if `r' == 8 { //pbs
		local yax "yscale(r(0 15)) ylab(0(5)15, $labfont)"
		local xlab "xlab(, $labfont)"		
		local k = 15
	}
	
	preserve
	
	merge m:1 qdate using "$inter/recession_data", nogen keep(3)
	
	replace USRECQ = 1 if USRECQ == 1.75
	replace USRECQ = USRECQ*`k'

	sum qdate if breaks_indc_`x' == 1
	local date1= r(mean)
	di "`date1'"		
		
	sum qdate if breaks_indc_`x' == 2
	local date2=r(mean)
	di "`date2'"		
	
	forval i = 1/2 {
	
	if `i' == 1 {
	local legend legend(off)
	local legend_setting 
	}
	if `i' == 2 {
	local legend legend( label(1 "Recession") label(2 "Unemployment Gap, u-u*") label(3 "Unemployment Rate, u") label(4 "Efficient Unemployment Rate, u*") cols(2) pos(6))
	local legend_setting "_appendix"
	}
	
	twoway  (area USRECQ qdate, color(gs14) ) (rarea u_star_`x' unemp_`x' qdate, color("194 189 206")) (line unemp_`x' qdate, lcolor("$purple") lwidth(medium)) (line u_star_`x' qdate, lcolor("$pink") lwidth(medium)) (, xline(`date1') xline(`date2')) , `legend' `yax' `xlab' xtitle("Quarter", $fontsize) ytitle("Unemployment Rate", $fontsize) note("Average Unemployment Gap 2000-2022: `mean_unemp_gap'" "Average Unemployment Gap 2000-2019: `mean_unemp_gap19'", size(medium))
	graph export "$graphs/efficientunemp_vs_actualunemp_`x'`legend_setting'.png", replace
	}
	restore
	local r = `r' + 1
}





twoway (line unemp_gap_manu qdate , lcolor("$orange") msymbol(O)) (line unemp_gap_cons qdate , lcolor("$pink") msymbol(D)) ///
	(line unemp_gap_ehs qdate , lcolor("$yellow") msymbol(T)) ///
	(line unemp_gap_finan qdate , lcolor("$blue") msymbol(S)) ///
	(line unemp_gap_lah qdate , lcolor("$purple") msymbol(+)) ///
	(line unemp_gap_pbs qdate , lcolor("$green") msymbol(X)) ///
	(line unemp_gap_tu qdate , lcolor(navy) msymbol(X)) ///
	(line unemp_gap_trade qdate , lcolor(maroon) msymbol(X)), ///
	legend( label(1 "Manufacturing") label(2 "Construction") label(3 "Edu/Health") label(4 "Finance") label(5 "Leisure/Hosp") label(6 "Prof/Bus") label(7 "Trans/Utilities") label(8 "Trade")) ///
	ytitle("Unemployment Gap") xtitle("Quarter") yscale(r(0 -35)) ylab(-35(5)0, $labfont)  xlab(, $labfont)
graph export "$graphs/unemp_gap_allind.png", replace	
	
graph bar (mean) unemp_gap_cons unemp_gap_trade unemp_gap_lah unemp_gap_manu unemp_gap_tu unemp_gap_pbs unemp_gap_finan unemp_gap_ehs, ///
 bar(1, fcolor("$pink") lcolor("$pink")) bar(2, fcolor(maroon) lcolor(maroon)) bar(3, fcolor("$purple") lcolor("$purple")) ///
 bar(4, fcolor("$orange") lcolor("$orange")) bar(5, fcolor(navy) lcolor(navy)) bar(6, fcolor("$green") lcolor("$green")) ///
 bar(7, fcolor("$blue") lcolor("$blue")) bar(8, fcolor("$yellow") lcolor("$yellow")) ///
 ytitle("Unemployment Gap (Efficient - Actual)") legend( label(1 "Construction") label(2 "Trade") label(3 "Leisure/Hosp") label(4 "Manufacturing") label(5 "Trans/Utilities") label(6 "Prof/Bus") label(7 "Finance") label( 8 "Edu/Health"))
graph export "$graphs/mean_unemp_gap_byind.png", replace	
	
	
local year_res "if year<=2019"


twoway (line unemp_gap_manu qdate `year_res', lcolor("$orange") msymbol(O)) ///
	(line unemp_gap_cons qdate  `year_res', lcolor("$pink") msymbol(D)) ///
	(line unemp_gap_ehs qdate `year_res', lcolor("$yellow") msymbol(T)) ///
	(line unemp_gap_finan qdate `year_res', lcolor("$blue") msymbol(S)) ///
	(line unemp_gap_lah qdate `year_res', lcolor("$purple") msymbol(+)) ///
	(line unemp_gap_pbs qdate `year_res', lcolor("$green") msymbol(X)) ///
	(line unemp_gap_tu qdate `year_res', lcolor(navy) msymbol(X)) ///
	(line unemp_gap_trade qdate `year_res', lcolor(maroon) msymbol(X)), ///
	legend( label(1 "Manufacturing") label(2 "Construction") label(3 "Edu/Health") label(4 "Finance") label(5 "Leisure/Hosp") label(6 "Prof/Bus") label(7 "Trans/Utilities") label(8 "Trade")) ///
	ytitle("Unemployment Gap") xtitle("Quarter") yscale(r(0 -20)) ylab(-20(5)0, $labfont)  xlab(, $labfont)
graph export "$graphs/unemp_gap_allind_pre2020.png", replace	
	

graph bar (mean) unemp_gap_cons unemp_gap_trade unemp_gap_lah unemp_gap_manu unemp_gap_tu unemp_gap_pbs unemp_gap_finan unemp_gap_ehs `year_res', ///
 bar(1, fcolor("$pink") lcolor("$pink")) bar(2, fcolor(maroon) lcolor(maroon)) bar(3, fcolor("$purple") lcolor("$purple")) ///
 bar(4, fcolor("$orange") lcolor("$orange")) bar(5, fcolor(navy) lcolor(navy)) bar(6, fcolor("$green") lcolor("$green")) ///
 bar(7, fcolor("$blue") lcolor("$blue")) bar(8, fcolor("$yellow") lcolor("$yellow")) ///
 ytitle("Unemployment Gap (Efficient - Actual)") legend( label(1 "Construction") label(2 "Trade") label(3 "Leisure/Hosp") label(4 "Manufacturing") label(5 "Trans/Utilities") label(6 "Prof/Bus") label(7 "Finance") label( 8 "Edu/Health"))
graph export "$graphs/mean_unemp_gap_byind_pre2020.png", replace	
	



keep unemp_gap_manu unemp_gap_cons unemp_gap_ehs unemp_gap_finan unemp_gap_lah unemp_gap_pbs unemp_gap_trade unemp_gap_tu

collapse (mean) unemp_gap_manu unemp_gap_cons unemp_gap_ehs unemp_gap_finan unemp_gap_lah unemp_gap_pbs unemp_gap_trade unemp_gap_tu


local varlist unemp_gap_manu unemp_gap_cons unemp_gap_ehs unemp_gap_finan unemp_gap_lah unemp_gap_pbs unemp_gap_trade unemp_gap_tu

local i = 1
foreach x of local varlist {
	rename `x' unemp_gap_`i'
	local i = `i'+ 1
}

gen x = 1

reshape long unemp_gap_, i(x) j(ind)

gen cat = ""
replace cat = "manu" if ind == 1
replace cat = "cons" if ind == 2
replace cat = "ehs" if ind == 3 
replace cat = "finan" if ind == 4
replace cat = "lah" if ind == 5
replace cat = "pbs" if ind == 6
replace cat = "trade" if ind == 7
replace cat = "tu" if ind == 8

drop ind x 

save "$inter/unemp_gap_by_ind", replace

}





********************************************************************************
*********************** Recruiting Cost by Industry Table **********************
********************************************************************************

if `rc_table' == 1 | `run_all' == 1 {


use "$inter/cost_of_recruiting", clear


graph bar rc_manu rc_cons rc_ehs rc_finan rc_lah rc_pbs


rename rc_manu rc_1
rename rc_cons rc_2 
rename rc_ehs rc_3
rename rc_finan rc_4
rename rc_lah rc_5
rename rc_pbs rc_6
rename rc_trade rc_7
rename rc_tu rc_8


reshape long rc_ , i(x) j(ind)


gen industry_name = "Manufacturing" if ind == 1
replace industry_name = "Construction" if ind == 2
replace industry_name = "Edu/Health" if ind == 3
replace industry_name = "Finance" if ind == 4
replace industry_name = "Leisure/Accom" if ind == 5
replace industry_name = "Prof/Business" if ind == 6
replace industry_name = "Trade" if ind == 7
replace industry_name = "Trans/Utilities" if ind == 8

drop x ind

replace rc_ = round(rc_, .01)


save "$inter/rc", replace
 
 
 
 
 
 

use "$inter/breaks", clear 

gen x = 1

merge m:1 x using "$inter/cost_of_recruiting", nogen


local ind manu cons ehs finan lah pbs trade tu
foreach x of local ind {
gen kappa_`x' = (rc_`x'*(1-(unemp_`x'/100)))/vac_`x'
}

collapse (mean) kappa*

rename kappa_manu kappa_1
rename kappa_cons kappa_2 
rename kappa_ehs kappa_3
rename kappa_finan kappa_4
rename kappa_lah kappa_5
rename kappa_pbs kappa_6
rename kappa_trade kappa_7 
rename kappa_tu kappa_8

gen x =1
reshape long kappa_ , i(x) j(ind)


 
gen industry_name = "Manufacturing" if ind == 1
replace industry_name = "Construction" if ind == 2
replace industry_name = "Edu/Health" if ind == 3
replace industry_name = "Finance" if ind == 4
replace industry_name = "Leisure/Accom" if ind == 5
replace industry_name = "Prof/Business" if ind == 6
replace industry_name = "Trade" if ind ==7 
replace industry_name = "Trans/Utilities" if ind ==8


replace kappa_ = round(kappa_, .01)

save "$inter/kappa", replace



use "$inter/number_of_firms", clear
merge 1:1 industry_name using "$inter/kappa", nogen
merge 1:1 industry_name using "$inter/rc", nogen


keep kappa_ rc_ counter industry_name
order industry_name

lab var counter "Number of Firms"
lab var kappa_ "Recruiters per Vacancy, $\kappa$"
lab var rc_ "% Labor Devoted to Recruiting"

sort kappa_

estpost tabstat rc_ kappa_ counter, by(industry_name)
 

texsave * using "$tables/rc_sum.tex", replace frag title("Recruiting by Industry") footnote("This table reports recruiting parameters by industry using the National Employers Survey. Column 1 reports the number of firms in each industry. Column 2 reports $\kappa$, the number of recruiters per vacancy within a industry. Column 3 reports the percent of labor firms within each industry devote to recruiting.") varlabels autonumber label("tab:rc")

}


