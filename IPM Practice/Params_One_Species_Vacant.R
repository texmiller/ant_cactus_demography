## -------- set working directory ---------------------- ##

setwd("/Users/alicampbell/Documents/GitHub/ant_cactus_demography/IPM Practice")

## -------- read in MCMC output ---------------------- ##

##This file contains random draws from the joint posterior distribution of all parameters
post.params <- read.csv("/Users/alicampbell/Dropbox/Ali and Tom -- cactus-ant mutualism project/Model Outputs/params_one_outputs.csv", header = TRUE,stringsAsFactors=T)  
trans.params <- read.csv("/Users/alicampbell/Dropbox/Ali and Tom -- cactus-ant mutualism project/Model Outputs/ant_outputs.csv", header = TRUE,stringsAsFactors=T) 
trans.params<-trans.params[,-c(1)]
Ndraws<-min(100,nrow(post.params))
trans.params<-trans.params[1:6,]

post.params$beta0_ant.1 <- trans.params$beta0.1
post.params$beta1_ant.1 <- trans.params$beta1.1
post.params$beta0_ant.2 <- trans.params$beta1.1
post.params$beta1_ant.2 <- trans.params$beta1.2

post.params<-post.params[1:Ndraws,]

## Number of draws to take from the joint posterior distribution of the parameters. 
## Cannot be greater than the number of draws provided in the .csv file, which is 500.
Nplots <- length(unique(cactus$Plot))
Nyears <- length(unique(cactus$Year_t))
iter <- 1000
matsize<-200
floor.extend=1
ceiling.extend=4
lower<- cholla[101] - floor.extend
upper<- cholla[102] + ceiling.extend
extra.grid=2

n<-matsize
L<-lower; U<-upper
h<-(U-L)/n                   #Bin size
b<-L+c(0:n)*h;               #Lower boundaries of bins 
y<-0.5*(b[1:n]+b[2:(n+1)]);  #Bin midpoints

## -------- load IPM source functions ---------------------- ##

source("Prac_One_Species_Vacant.R")

## -------- Set up IPM parameter vector ---------------------- ##

## 'cholla' is a matrix where rows are vital rate coefficients and columns are posterior draws
## below, we will loop over columns, sending each set of coefficients into the stochastic IPM
cholla<-matrix(NA,nrow=400,ncol=Ndraws) 

##----------------------Growth Parameters----------------## 
####Ant 1 (crem)
cholla[1,]<-post.params$beta0_g.1      	  ## growth intercept
cholla[2,]<-post.params$beta1_g.1				  ## growth slope
cholla[3,]<-post.params$sigma_g			      ## growth error
cholla[4,]<-post.params$sigma_u_g  	      ## growth plotfx error
cholla[5,]<-post.params$sigma_w_g         ## growth yrfx error
####Ant 2 (liom)
#cholla[101,]<-post.params$beta0_g.2      	  ## growth intercept
#cholla[102,]<-post.params$beta1_g.2				  ## growth slope
####Ant 3 (Other)
#cholla[201,]<-post.params$beta0_g.3      	  ## growth intercept
#cholla[202,]<-post.params$beta1_g.3				  ## growth slope
####Ant 4 (Vacant)
cholla[301,]<-post.params$beta0_g.4      	  ## growth intercept
cholla[302,]<-post.params$beta1_g.4				  ## growth slope

##-----------------------Survival Parameters-----------------## 
####Ant 1 (crem)
cholla[11,]<-post.params$beta0_s.1      	## surv intercept
cholla[12,]<-post.params$beta1_s.1				## surv slope
cholla[13,]<-post.params$sigma_s			    ## surv error
cholla[14,]<-post.params$sigma_u_s  	    ## surv plotfx error
cholla[15,]<-post.params$sigma_w_s        ## surv yrfx error
####Ant 2 (liom)
cholla[111,]<-post.params$beta0_s.2      	## surv intercept
cholla[112,]<-post.params$beta1_s.2				## surv slope
####Ant 3 (other)
cholla[211,]<-post.params$beta0_s.3      	## surv intercept
cholla[212,]<-post.params$beta1_s.3				## surv slope
####Ant 4 (Vacant)
cholla[311,]<-post.params$beta0_s.4      	## surv intercept
cholla[312,]<-post.params$beta1_s.4				## surv slope

##-----------------------Flowering/Fecundity Parameters-----------------## 
cholla[21,]<-post.params$beta0_f      	  ## flower intercept
cholla[22,]<-post.params$beta1_f				  ## flower slope
cholla[23,]<-post.params$sigma_f			    ## flower error
cholla[24,]<-post.params$sigma_u_f  	    ## flower plotfx error
cholla[25,]<-post.params$sigma_w_f        ## flower yrfx error
cholla[26,]<-post.params$phi_f            ## flower dispersion parameter

##-----------------------Reproductive State Parameters-----------------## 
cholla[31,]<-post.params$beta0_r      	  ## repro intercept
cholla[32,]<-post.params$beta1_r				  ## repro slope
cholla[33,]<-post.params$sigma_r			    ## repro error
cholla[34,]<-post.params$sigma_u_r  	    ## repro plotfx error
cholla[35,]<-post.params$sigma_w_r        ## repro yrfx error

##-----------------------Viability Parameters-----------------## 
####Ant 1 (crem)
cholla[41,]<-post.params$beta0_v.1      	## viab coeff 
cholla[42,]<-post.params$sigma_v			    ## viab error
cholla[43,]<-post.params$sigma_u_v  	    ## viab plotfx error
cholla[44,]<-post.params$sigma_w_v        ## viab yrfx error
####Ant 2 (liom)
cholla[141,]<-post.params$beta0_v.2      	## viab coeff 
####Ant 3 (other)
cholla[241,]<-post.params$beta0_v.3      	## viab coeff 
####Ant 4 (vacant)
cholla[341,]<-post.params$beta0_v.4      	## viab coeff 

##-----------------------Seeds Prod Parameters-----------------## 
####Ant 1 (crem)
cholla[51,]<-post.params$beta0_seed.1     ## seed intercept
cholla[52,]<-post.params$sigma_seed			  ## seed error
cholla[53,]<-post.params$phi_seed         ## seed dispersion parameter

##-----------------------Seeds Surv Parameters-----------------## 
cholla[61,]<-post.params$beta0_seed_s.1     ## seed intercept
cholla[62,]<-post.params$sigma_seed_s			  ## seed error
cholla[63,]<-post.params$phi_seed_s         ## seed dispersion parameter

##-----------------------Germ1 Parameters-----------------## Ant 1 (crem)
cholla[71,]<-post.params$beta0_germ1        ## germ intercept
cholla[72,]<-post.params$beta1_germ1        ## germ slope
cholla[73,]<-post.params$sigma_germ1        ## germ error
cholla[74,]<-post.params$phi_germ1          ## germ dispersion parameter

##-----------------------Germ2 Parameters-----------------## Ant 1 (crem)
cholla[81,]<-post.params$beta0_germ2        ## germ intercept
cholla[82,]<-post.params$beta1_germ2        ## germ slope
cholla[83,]<-post.params$sigma_germ2        ## germ error
cholla[84,]<-post.params$phi_germ2          ## germ dispersion parameter

##-----------------------Precensus Surv Parameters-----------------## Ant 1 (crem)
cholla[91,]<-post.params$beta0_precen       ## precen intercept
cholla[92,]<-post.params$beta1_precen       ## precen slope
cholla[93,]<-post.params$sigma_precen       ## precen error


## Params 61-70: Misc params (bounds of continuous size domain, in units of log(cm^3)). Hard coded from Miller's data. 
cholla[94,]<- min(log(cactus$volume_t), na.rm = TRUE)  ## minsize 
cholla[95,]<- max(log(cactus$volume_t), na.rm = TRUE)  ## maxsize 

## Recruitment
cholla[96,]<-post.params$beta0_rec         ## Rec intercept
cholla[97,]<-post.params$sigma_rec         ## Rec error

## Transition
cholla[98,]<-post.params$beta0_ant.1       ## prob from t vac to t1 crem
cholla[99,]<-post.params$beta1_ant.1       ## prob from t vac to t1 crem
cholla[100,]<-post.params$beta0_ant.2      ## prob from t crem to t1 crem
cholla[101,]<-post.params$beta1_ant.2      ## prob from t crem to t1 crem
cholla[102,]<-post.params$sigma_ant

for(i in 1:Ndraws) {
  
  ## sample a sequence of random deviates representing plot-to-plot variance in each of the four main vital rates
  yrfx <- matrix(0,5,Nplots)
  yrfx[1,] <- rnorm(n=Nplots,mean=0,sd=cholla[6,i]) # Growth
  yrfx[2,] <- rnorm(n=Nplots,mean=0,sd=cholla[15,i]) # Survival 
  yrfx[3,] <- rnorm(n=Nplots,mean=0,sd=cholla[25,i]) # Repro 
  yrfx[4,] <- rnorm(n=Nplots,mean=0,sd=cholla[35,i]) # Flowers
  yrfx[5,] <- rnorm(n=Nplots,mean=0,sd=cholla[44,i]) # Viability
  ## sample a sequence of random deviates representing year-to-year variance in each of the four main vital rates, individually
  plotfx <- matrix(0,5,iter)  
  plotfx[1,] <- rnorm(n=iter,mean=0,sd=cholla[5,i]) # Growth
  plotfx[2,] <- rnorm(n=iter,mean=0,sd=cholla[14,i]) # Survival 
  plotfx[3,] <- rnorm(n=iter,mean=0,sd=cholla[24,i]) # Probability of flowering 
  plotfx[4,] <- rnorm(n=iter,mean=0,sd=cholla[34,i]) # Fertility
  plotfx[5,] <- rnorm(n=iter,mean=0,sd=cholla[43,i]) # Viability
}


##### #Run the matrix once with quantile values for the betas
gxy(4, 5,cholla,"crem")

sx(4, cholla,i)

pxy(4, 5, cholla,i)

fx(4,cholla,i) ## Not Working



a <- bigmatrix(cholla,lower,upper,matsize)
IPM_mat<- a$IPMmat
T_mat <- a$Tmat
F_mat <- a$Fmat
lambda.fun(cholla,iter,matsize,extra.grid = 2,floor.extend = 1, ceiling.extend = 4,i,j)


bigmatrix(cholla,lower,upper,n,"crem","crem")
sum()
