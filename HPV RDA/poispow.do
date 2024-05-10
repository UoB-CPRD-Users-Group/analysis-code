/* poispow.do - does power estimation for Poisson regression model

model: log(mu) = b0 + b1*x
       y ~ Poisson(mu)

Specifically, power is estimated for testing the hypothesis b1 = 0, against a
user-specified alternative for a user-specified sample size. Without loss of
generality, we can assume the true value of b0 is 0.

In the `args' statement below:

        N is number of iterations in the simulation
        r is the number of rats receiving the jth dose (j=1,3) 
        d1, d2 and d3 are the fixed dosages
        b1 is the "true" value of b1 (the alternative hypothesis).
*/

version 15  
args N r d1 d2 d3 b1
drop _all
set obs 3
generate x=`d1' in 1
replace x=`d2' in 2
replace x=`d3' in 3
expand `r'
sort x
generate mu=exp(0 + `b1'*x)   /* (the "zero" is to show b0 = 0) */
save tempx, replace

/* Note: Here, I generated my "x" and mu-values and stored them in a dataset
-tempx- so that the same values could be used throughout the simulation  */

/* set up a dataset with N observations which will eventually contain N 
"p"-values obtained by testing b1=0.  */
drop _all
set obs `N'
generate pv = .

/* Loop through the simulations */

local i 0
while `i' < `N' {
     local i=`i'+1
     preserve

     use tempx,clear        /* get the n = 3*r observations of x 
                               and the mean mu into  memory  */
     gen xp = rpoisson(mu)             /* generate n obs. of a Poisson(mu)random
                               variable in variable -xp- */
     quietly poisson xp x           /* do the Poisson regression */
     matrix V=e(V)          /* get the standard-error matrix */
     matrix b=e(b)          /* get the vector of estimated coefficients */
     scalar tv=b[1,1]/sqrt(V[1,1])          /* the "t"-ratio */
     scalar pv = 2*(1-normal(abs(tv)))    /* the p-value  */
     restore /* get back original dataset with N observations */
     quietly replace pv=scalar(pv) in `i'           /* set pv to the p-value for
                                               the ith simulation */
      _dots `i' 0
}

/*The dataset in memory now contains N simulated p-values. To get an
estimate of the power, say for alpha=.05, just calculate the proportion
of pv's that are less than 0.05:  */

count if pv<.05
scalar power=r(N)/`N'
scalar n=3*`r'
noisily display "Power is " %8.4f scalar(power) " for a sample size of " /*
	*/ scalar(n) " and alpha = .05"
exit
