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
*frequency table shows percentage of dependent variable in each independent varaible category. Total shows percentage of the variable category among total variable 


*Part 2 
*Hypothesis: Is there difference in mean plasma glucose conc in participants that have diabetes and do not have diabetes?
*Variable of interest: mean plasma glucose conc 
*Parameter of interest: Difference in mean plasma glucose conc between diabetes and non diabetes partcipants
*Test statistic- We conduct a 2 sided 2-sample t-test of means with equal or unequal variances, but first we have to determine if the variances are equal 
*Using alpha=0.05 and df=1006,492

*Performing an f test CI 95% to determine if diabetes and non diabetes participants have equal mean variance for plasma glucose concentration
*alpha=0.05
* Df= 872.6
*Hnull= Variances are equal  Halt= Variances are not equal 
 * Decision factor: If pvalue < 0.05 variances are unequal but If pvalue>0.05 variances are equal 
sdtest plasgluc, by(dm)
*Result:Pvalue < 0.05, Therefore reject the null and conclude tests are unequal 

*Next we conduct a 2 sided 2 independent sample t-test of means with unequal variance 
ttest plasgluc, by(dm) unequal
*Result:Pvalue <0.05 and CI does not inlcude 0, so we reject null and conclude there is a difference in plasma glucose conc between diabetes and non diabetes participants. 
Also, we can conclude that diabetes group has greater mean plasma glucose concentration than the non-diabetes group

****PART 3
** Testing our second hypothesis 
*Our second hypothesis is whether or not there is a difference in the
diastolic blood pressure groups between those who have diabetes and those that do not.

* Computing expected values for the 2x2 Contingency table
tab dm dbpgroup, exp

**We choose to perform a chi square test of independence large sample since
all expected cells were greater than or equal to 5 and there was nothing in the data that suggested that samples were
paired, so independence assumption was satisfied.

***Computing chi square test for independence (large sample)
tab dm dbpgroup, chi2 exp

**The chi square test for independence (large sample test) for our 2 nd hypothesis gave a X 2 statistic
of 7.5335 with p value 0.006. Since we indicated that pvalue &lt; 0.05 is the rejection region, we
reject our null hypothesis. Therefore, we conclude that there is sufficient evidence that the
probability of having high bp and no high bp by is different for participants who have diabetes vs
no diabetes.

**Next, we run simple linear regression models to test the association between the dependent variable 2hour insulin levels and the
independent variables: Age groups, Plasma glucose concentration, Diastolic blood pressure
groups and smoking status.

* Identifying missing values
replace insulin2h= . if insulin2h== 9
replace agegroup= . if agegroup== 9
replace plasgluc= . if plasgluc==9
replace dbpgroup = . if dbpgroup==9
replace smoking_status= . if smoking_status==9

* Model 1) Regressing plasgluc 
scatter insulin2h plasgluc
**No relationship was found between insulin and plasma glucose concentration, so we transform plasma glucose 
qladder plasgluc
gladder plasgluc

* Check assumption for Simple Linear regression: normal residuals

***Model 2) Regressing agegroup 
* Creating dummy variables 
tabulate agegroup, gen(age1)
tab agegroup age11
tab agegroup age12
*regression
regress insulin2h age11 age12

***Model 3) Regressing dpgroup
*Creating dummy variables for dpbgroup 
tabulate dbpgroup, gen(dpbs)
tab dbpgroup dpbs1
tab dbpgroup dpbs2

regress insulin2h dpbs1 dpbs2

**Model 4)Regressing smoking_status
*Creating dummy varaibles for smoking_status
tabulate smoking_status, gen(smokes)
tab smoking_status smokes1
tab smoking_status smokes2
tab smoking_status smokes3
tab smoking_status smokes4
regress insulin2h smokes1 smokes2 smokes3 smokes4 smokes5
 
 **The only significant regression coefficient was for model 2,
plasma glucose concentration (p value <=0.05). However, even with the significant test, only
18.4% of the variation of 2hr insulin can be explained by the model.


*Performing our multi variable regression (Final model)

regress insulin2h plasgluc i.dbpgroup i.agegroup i.smoking_status


*Computing residuals and Checking assumptions for the Final Model 

predict e2, residuals
predict standresid2, rstandard
predict studresid2, rstudent


*Assessing normality of residuals for final model
qnorm e2
qnorm standresid2
qnorm studresid2
hist e2, normal
hist standresid2, normal
hist studresid2, normal
swilk e2
swilk standresid2
swilk studresid2
twoway (scatter e2 insulin2h, msymbol(circle_hollow)) (qfit e2 insulin2h), ytitle(Residuals) xtitle(insulin2h)
twoway (scatter standresid2 insulin2h, msymbol(circle_hollow)) (qfit standresid2 insulin2h), ytitle(standresid2) xtitle(insulin2h)
twoway (scatter studresid2 insulin2h, msymbol(circle_hollow)) (qfit studresid2 insulin2h), ytitle(studresid2) xtitle(insulin2h)
list e2

*The histogram plots for residuals did not follow the normal curve, they resembled a right skewed distribution 
*The q-q plots did not have most of the data points on the line, instead the points followed a curve across the regresion line 
*Shapiro wilk test results for normality of residuals gave pvalue <0.001 for unadjusted, studentized and standardized residuals. Normality assumption is not satisfied
*For homoscedasticity and linearity assumptions, we examined the residual scatter plot fitted against outcome variable insulin2h 
We can see that most of the data points closely follow the diagonal regression line, meaning linearity assumption is satisfied 
Homoscedasticity is also satisfied since there is no obvious pattern around the regression line
Finally, the Independence assumption was checked using the list command to see if each observation was indepednent of the other. The assumption is satisfied since there is no indication of paired or matched observations
