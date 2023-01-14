clear 
use "H:\.dta folder\pimaindians1500_08302021-2.dta"

* Part 1 final project
Continous variables: Plasgluc, insulin2h
normal : plasgluc, insulin2h
Categorical variables: Age group, dbpgroup, smoking_status

*Labelling our categorical variables 
label define dm 0 "no_diabetes" 1 "diabetes"
label values dm dm
label define agegroup 0 "less than 35" 1 "35 above", replace
label values agegroup agegroup
label define smoking_status 1 "cigarettes" 2 "e-cigarettes" 3 "cigars" 4 "non-smoker" 5 "dual tobacco products"
label values smoking_status smoking_status
label define dbpgroup 0 "not_high_bp" 1 "high_bp"
label values dbpgroup dbpgroup

* Assessing continous variables for normality (box plot and quintile-quantile plots)
graph box plasgluc, over(dm) title(Box plot of plasma glucose concentration at 2 hours by diabetes diagnosis)
graph box insulin2h, over(dm) title(Boxplot of 2 hour serum insulin by diabetes diagnosis)

qnorm plasgluc
qnorm insulin2h

swilk plasgluc 
swilk insulin2h
*Swilk tests pvalues were all <0.001, but sample size is large enough so assume CLT

*Requested graph of 2 hr serum insulin by diastolic bp group
graph box insulin2h, over(dbpgroup) title(Box plot of 2 hour serum insulin by diastolic bp group)

*Computing summary statistic (mean and SD) for key continuous variables 
by dm, sort : summarize plasgluc
by dm, sort : summarize insulin2h
summarize insulin2h 
summarize plasgluc


*Frequency statistics, Categorical variables
tabulate dbpgroup dm
tabulate agegroup dm
tabulate smoking_status dm


*Part 2 
*Is there difference in mean plasma glucose conc in participants that have diabetes and do not have diabetes
*Variable of interest: mean plasma glucose conc 
*Parameter of interest: Difference in mean plasma glucose conc between diabetes and non diabetes partcipants
*Test statistic- We conduct a 2 sided 2-sample t-test of means with equal or unequal variances, but first we have to determine if the variances are equal 
*Using alpha=0.05 and df=?????????????

*Performing an f test CI 95% to determine if diabetes and non diabetes participants have equal mean variance for plasma glucose concentration
*alpha=0.05
* Df= ??????
*Hnull= Variances are equal  Halt= Variances are not equal 
 * Decision factor: If pvalue < 0.05 variances are unequal If pvalue>0.05 variances are equal 
sdtest plasgluc, by(dm)
*Pvalue < 0.05, Therefore rejcet the null and conclude tests are unequal 

*Next we conduct a 2 sided 2-sample t-test of means with unequal variance 
ttest plasgluc, by(dm) unequal

****PART 3
** Hypothesis 2 test 
* Computing expected values for teh 2x2 Contingency table
tab dm dbpgroup, exp
***Computing chi square test for independence (large sample)
tab dm dbpgroup, chi2 exp

* Identifying missing variables 
replace insulin2h= . if insulin2h== 9
replace agegroup= . if agegroup== 9
replace plasgluc= . if plasgluc==9
replace dbpgroup = . if dbpgroup==9
replace smoking_status= . if smoking_status==9

* 1) Regressing plasgluc 
scatter insulin2h plasgluc
**No relationship was found between insulin and plasma glucose conc so we transform plasma glucose 
qladder plasgluc
gladder plasgluc

* Assumptions for Simple Linear regression: If independent varaible is continuous, it shoudl be normal????

* Checking normaliity of dependent variable (insulin2h) and independent varaible  (plasgluc)
swilk insulin2h
swilk plasgluc
**Perfrom regression (F test ANOVA table and t test)
regress insulin2h plasgluc

***2) Regressing agegroup 
* Creating dummy variables 
tabulate agegroup, gen(age1)
tab agegroup age11
tab agegroup age12
*regression
regress insulin2h age11 age12

***3) Regressing dpgroup
*Creating dummy variables for dpbgroup 
tabulate dbpgroup, gen(dpbs)
tab dbpgroup dpbs1
tab dbpgroup dpbs2

regress insulin2h dpbs1 dpbs2

**Regressing smoking_status
*Creating dummy varaibles for smoking_status
tabulate smoking_status, gen(smokes)
tab smoking_status smokes1
tab smoking_status smokes2
tab smoking_status smokes3
tab smoking_status smokes4
regress insulin2h smokes1 smokes2 smokes3 smokes4 smokes5
 

**Test of homogeneity (varaiance)
**Do this for all independent variables
sdtest insulin2h = plasgluc 
sdtest insulin2h = agegroup
**The vraible insulin2h is not constant for all age groups. We have aproblme with teh vraince since the varaince is not homogenouos 
<0.001, homogeniety is not met. Variance will differ 