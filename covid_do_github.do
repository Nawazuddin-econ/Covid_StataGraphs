**run this
import excel "state_wise_daily.xlsx", firstrow clear
ren *,lower
keep if status=="Confirmed"
save confirmed_1
gen n=_n
drop if n<7
drop n
gen Days=_n
gen MA5=(mp[_n-5]+mp[_n-4]+mp[_n-3]+mp[_n-2]+mp[_n-1])/5 //moving average
label var mp  "Daily Confirmed Cases"
label var MA5 "5 Day Moving Avergae"
twoway (spike mp Days,  lwidth(none)  xlabel(1(5)80) yscale(alt  axis(1)) )(line  MA Days, yaxis(1) yscale(alt axis(1)) mcolor("255 255 255") sort), title("COVID-19 daily new cases and 5 day Moving Average", span size(medium)) subtitle("In Madhya Pradesh as on June 7", span size(medium)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee", span size(medium))
****
**_________________________________________
**10 june
import delimited "statewise_tested_numbers_data",clear
keep if state=="Madhya Pradesh"
gen n=_n

destring positive,replace
gen Dailytestincreae=totaltested[_n]-totaltested[_n-1]
gen test_posve=(positive/Dailytestincreae)*100
label var test_posve "Test Positive Rate"
label var Dailytestincreae "Daily Tests"
label var positive "Daily New Cases"

ren updatedon date
gen date_1 = date(date, "DM20Y")
gen long wanted = year(date_1)*10000+month(date_1)*100+day(date_1)
format wanted %8.0f
gen date2 = date(date, "DM20Y")
format date2 %td
drop if test_posve==.
twoway bar Dailytest  date2 , yaxis(1)  yla(0(2000)8000) || (line test_posve date2  , yaxis(2) lcolor(cranberry)),  yline(250, axis(1) lstyle(foreground)) yscale(range(-.3 .3) axis(2)) title("Progression of COVID-19 cases in Madhya Pradesh as on June 7",  size(small)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee", size(small)) ytitle("Number of Tests",  size(small))  


graph bar (asis) Dailytestincreae,  over(date2)    blabel(bar, position(outside) format(%4.0f) color(black)) scheme(s2color)    bargap(5)  nofill xsize(20) title("Daily Tests of COVID-19 in Madhya Pradesh as on June 9") note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee") ysize(10)

*_____________________________________________
**13 june
cd "F:\COVID" //change you working directory
import excel "state_wise_daily_1", sheet("state_wise_daily_1") firstrow clear
keep if Status=="Confirmed"
drop Status
ren MP Confirmed
gen n=_n
save Confirmed

import excel "state_wise_daily_1", sheet("state_wise_daily_1") firstrow clear
keep if Status=="Recovered"
ren MP Recovered
drop Status
gen n=_n
save Recovered

import excel "state_wise_daily_1", sheet("state_wise_daily_1") firstrow clear
keep if Status=="Deceased"
drop Status
ren MP Deceased
gen n=_n
save Deceased


use Confirmed,clear
merge 1:1 n using Recovered
drop _merg
merge 1:1 n using Deceased
drop _merge
save total_mp.dta      
gen Days=_n
gen Date_1=Date


gen TCC=sum( Confirmed )
gen TDC=sum( Deceased )
gen TRC=sum( Recovered )
gen TAC= TCC- TRC- TDC

*****
 gen GR_CC= (D.TCC / L.TCC)*100
******

gen MA5=(Confirmed[_n-5]+Confirmed[_n-4]+Confirmed[_n-3]+Confirmed[_n-2]+Confirmed[_n-1])/5 
**OR
tssmooth ma MA5 = Confirmed, window(5)

label var Confirmed  "Daily Confirmed Cases"
label var MA5 "5 Day Moving Avergae"
gen T = string(Date, "%tqCCYY-q") 
help labmask
labmask Date, values(T)
tsset Date
foreach i in 20march2020 21march2020 22march2020 23march2020 07june2020{
	di d(`i') 
 }
twoway (bar Confirmed Date,  lwidth(none)  xla(21994(5)22073) xla(,angle(vertical)) yscale(alt  axis(1))  barw(.1))(line  MA5 Date, yaxis(1) yscale(alt axis(1)) mcolor("255 255 255") sort), title("COVID-19 daily new cases and 5 day Moving Average", span size(medium) color(black))  subtitle("In Madhya Pradesh as on June 7, TCC=9401", span size(medsmall) color(black)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee", span size(small))
***OR with white background
twoway (bar Confirmed Date,  lwidth(none)  xla(21994(5)22073) xla(,angle(vertical)) yscale(alt  axis(1))  barw(.1))(line  MA5 Date, yaxis(1) yscale(alt axis(1)) mcolor("255 255 255") sort), graphregion(color(white)) title("COVID-19 daily new cases and 5 day Moving Average", span size(medium) color(black))  subtitle("In Madhya Pradesh as on June 7, TCC=9401", span size(medsmall) color(black)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee", span size(small))


 gen GR_CC= (D.TCC / L.TCC)*100

gen MA7_confirm=( GR_CC [_n-7]+ GR_CC [_n-6]+ GR_CC [_n-5]+ GR_CC [_n-4]+ GR_CC [_n-3]+ GR_CC [_n-2]+ GR_CC [_n-1])/7
gen MA7_confirm_1=( Confirmed [_n-7]+ Confirmed [_n-6]+ Confirmed [_n-5]+ Confirmed [_n-4]+ Confirmed [_n-3]+ Confirmed [_n-2]+ Confirmed [_n-1])/7
label var MA7_confirm "Avg. Growth"
foreach i in 24march2020 15april2020 03may2020 17may2020  31may2020 10june2020 {
	di d(`i') 
 }
twoway (area TCC TAC TRC TDC Date , yaxis(1) xla(21994(5)22073) xla(,angle(vertical) labsize(small)) ) (line MA7_confirm Date, yaxis(2) lcolor(cranberry) ), yline(250, axis(1) lstyle(foreground)) yscale(range(-.3 .3) axis(2)) title("Progression of COVID-19 cases in Madhya Pradesh as on June 7", span size(small)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee", span size(vsmall)) ttext(10000 21996 "Pre Lockdown", size(vsmall))    ttext(10000 22008 "Lockdown I", size(vsmall))  ttext(10000 22028 "Lockdown II", size(vsmall))  ttext(10000 22045 "Lockdown III", size(vsmall)) ttext(10000 22059 "Lockdown IV", size(vsmall))   xline(21998)  xline(22020) xline(22038) xline(22052) xline(22066) legend(cols(5))
*******OR without text
twoway (area TCC TAC TRC TDC Days , yaxis(1)) (line MA7_confirm_1 Days, yaxis(2) lcolor(cranberry) ), yline(250, axis(1) lstyle(foreground)) yscale(range(-.3 .3) axis(2)) title("Progression of COVID-19 cases in Madhya Pradesh as on June 7", span size(small)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee", span size(small))
*_______________________________________________________________________________________________

***17 June

cd "F:\COVID"
erase a1.dta
erase a2.dta
erase a3.dta

import excel "state_wise_daily _17_june", sheet("state_wise_daily _17_june") firstrow clear
keep if Status=="Confirmed"
rename * CO_*
gen n=_n
save a1


import excel "state_wise_daily _17_june", sheet("state_wise_daily _17_june") firstrow clear
keep if Status=="Recovered"
rename * Re_* 
gen n=_n
save a2

import excel "state_wise_daily _17_june", sheet("state_wise_daily _17_june") firstrow clear
keep if Status=="Deceased"
rename * De_*
gen n=_n
save a3


use a1,clear
merge 1:1 n using a2
drop _merg
merge 1:1 n using a3
drop _merge



gen TCC_MP=sum( CO_MP )
gen TDC_MP=sum( De_MP )
gen TRC_MP=sum( Re_MP )
gen TAC_MP= TCC_MP- TRC_MP- TDC_MP

gen TCC_TT=sum( CO_TT )
gen TDC_TT=sum( De_TT )
gen TRC_TT=sum( Re_TT )
gen TAC_TT= TCC_TT- TRC_TT- TDC_TT

gen GR_MP=((TCC_MP[_n]-TCC_MP[_n-1])/TCC_MP[_n-1])*100
gen GR_TT=((TCC_TT[_n]-TCC_TT[_n-1])/TCC_TT[_n-1])*100

gen fiveD_avg_MP=(GR_MP[_n]+ GR_MP[_n-1]+ GR_MP[_n-2] + GR_MP[_n-3]+ GR_MP[_n-4])/5

gen fiveD_avg_TT=(GR_TT[_n]+ GR_TT[_n-1]+ GR_TT[_n-2] + GR_TT[_n-3]+ GR_TT[_n-4])/5

gen doubling_time_MP=70/fiveD_avg_MP

gen doubling_time_TT=70/fiveD_avg_TT

foreach i in  14march2020 18march2020 19march2020 25march2020 30march2020 15april2020 15june2020  16june2020  17june2020 {
	di d(`i') 
 }

twoway (line doubling_time_MP CO_Date , lw(thick) xla(21988(5)22083) xla(, angle (vertical) labsize(vsmall))) (line doubling_time_TT CO_Date ,lw(thick)) ,  ytitle(Doubling time in days) title("COVID-19: Doubling time in days for Madhya Pradesh and All India", size(medium) color(black)) subtitle("Calculated retrospectively on 5-day rolling basis: Data Updated as on June 17", size(small) color(black)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee") text(45 22081 "47 Days", size(small)) text(21.5 22081 "20 Days",size(small)) text(43.5 22015 "Total Confirmed Cases as on June 17 (All India):372264", size(small)) text(40.5 22012 "Total Confirmed Cases as on June 17 (MP):11244", size(small)) legend(label(1 "Doubling Time (MP)") label(2 "Doubling Time (All India)"))

*****OR with white background
twoway (line doubling_time_MP CO_Date , lw(thick) xla(21988(5)22083) xla(, angle (vertical) labsize(vsmall))) (line doubling_time_TT CO_Date ,lw(thick)) ,  ytitle(Doubling time in days) title("COVID-19: Doubling time in days for Madhya Pradesh and All India", size(medium) color(black)) subtitle("Calculated retrospectively on 5-day rolling basis: Data Updated as on June 17", size(small) color(black)) note("Data Source: India COVID-19 Tracker, https://www.covid19india.org/" "Nawazuddin Ahmed, Doctoral Scholar (Economics) IIT Roorkee") text(45 22081 "47 Days", size(small)) text(21.5 22081 "20 Days",size(small)) text(43.5 22015 "Total Confirmed Cases as on June 17 (All India):372264", size(small)) text(40.5 22012 "Total Confirmed Cases as on June 17 (MP):11244", size(small)) graphregion(color(white)) legend(label(1 "Doubling Time (MP)") label(2 "Doubling Time (All India)"))
