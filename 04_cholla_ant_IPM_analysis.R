#######################################################################################################
#######################################################################################################
##                            Call the IPM and understand the outputs                                ##
#######################################################################################################
#######################################################################################################
setwd("/Users/alicampbell/Documents/GitHub/ant_cactus_demography/IPM Code")
## Set the colors for the visuals
vcol <- "#ad90ec"
lcol <- "#084f98"
ccol <- "#e9a67a"
ocol <- "#93022f"
lccol <- "#5dc9cf"
locol <- "#cf3545"
cocol <- "#ab59c8"
acol <- "#5d906b"
cols <- c(vcol, ccol, lcol, ocol, lccol, locol, cocol, acol)

######################################################################################################
############################### DETERMINISTIC POST IPM ###############################################
##                        Calculate the lambda posterior distributions                              ##
######################################################################################################
######################################################################################################
#### Calculate the lambda posterior distributions
# Create an empty matrix to fill with the lambda estimations using functions defined in IPM_Post.R
# Rows correspond to parameter iterations
# Columns correspond to partner scenarios
lams_dpost <- matrix(rep(NA, 1*8), nrow = 1, ncol = 8)
m=1
scenario = c("none","cremvac","liomvac","othervac","liomcremvac","liomvacother","othercremvac","all")
for(z in 1:length(scenario)){
  print(z)
  #for(m in 1:100){
  lams_dpost[m,z] <- lambda(bigmatrix(params[m,],lower,upper,matsize,scenario[z])$IPMmat)
  #}
}
lams_dpost
# Set the names of each column to the corresponding partner scenario and save the results as a csv
colnames(lams_dpost) <- scenario
write.csv(lams_dpost,"det_post_lambda.csv")

######################################################################################################
################################## STOCHASTIC POST IPM ###############################################
##                       Calculate the lambda posterior distributions                         ########
######################################################################################################
######################################################################################################
#### Calculate the lambda posterior distributions with stochasticity
# Set the order or the scenarios
scenario = c("none","cremvac","liomvac","othervac","liomcremvac","liomvacother","othercremvac","all")
max_scenario = length(scenario)
# Choose the number of parameter iterations 
max_rep = 100 ## Posterior Draws from vital rate models
# Choose the number of years for stochasticity
max_yrs = 100 ## Years of randomly sampled annual effects
# Create an empty matrix to fill with the lambda estimations using functions defined in IPM_Stochastic_Post.R
# Rows correspond to parameter iterations
# Columns correspond to partner scenarios
lams_stoch <- matrix(nrow = max_rep, ncol = max_scenario)
for(n in 1:max_scenario){
  print(scenario[n])
  #for(m in 1:max_rep){
  lams_stoch[m,n] <- lambdaSim(params = params[m,],## parameters
                               grow_rfx1 = grow_rfx1[m,],
                               grow_rfx2 = grow_rfx2[m,],
                               grow_rfx3 = grow_rfx3[m,],
                               grow_rfx4 = grow_rfx4[m,],
                               surv_rfx1 = surv_rfx1[m,],
                               surv_rfx2 = surv_rfx2[m,],
                               surv_rfx3 = surv_rfx3[m,],
                               surv_rfx4 = surv_rfx4[m,],
                               flow_rfx = flow_rfx[m,],
                               repro_rfx = repro_rfx[m,],
                               viab_rfx1 = viab_rfx1[m,],
                               viab_rfx2 = viab_rfx2[m,],
                               viab_rfx3 = viab_rfx3[m,],
                               viab_rfx4 = viab_rfx4[m,],## viability model year rfx
                               max_yrs = max_yrs,        ## the # years you want to iterate
                               matsize=matsize,          ## size of transition matrix
                               scenario = scenario[n],   ## partner diversity scenario
                               lower=lower,upper=upper  )
  #}
}
# Set the names of each column to the corresponding partner scenario and save the results as a csv
colnames(lams_stoch) <- scenario
write.csv(lams_stoch,"stoch_post_lambda.csv")

######################################################################################################
################################## STOCHASTIC NULL POST IPM ##########################################
##                       Calculate the lambda posterior distributions                               ##
######################################################################################################
######################################################################################################
#### Calculate the lambda posterior distributions with stochasticity and no possible synchronicity of 
#### ant effects
# Set the order or the scenarios
scenario = c("none","cremvac","liomvac","othervac","liomcremvac","liomvacother","othercremvac","all")
max_scenario = length(scenario)
# Choose the number of parameter iterations 
max_rep = 100 ## Posterior Draws from vital rate models
# Choose the number of years for stochasticity
max_yrs = 100 ## Years of randomly sampled annual effects
# Create an empty matrix to fill with the lambda estimations using functions defined in IPM_Stochastic_Post.R
# Rows correspond to parameter iterations
# Columns correspond to partner scenarios
lams_stoch_null <- matrix(nrow = max_rep, ncol = max_scenario)
for(n in 1:max_scenario){
  print(scenario[n])
  for(m in 1:max_rep){
    lams_stoch_null[m,n] <- lambdaSim(params = params[m,],## parameters
                                      grow_rfx1 = grow_rfx1[m,],
                                      grow_rfx2 = grow_rfx1[m,],
                                      grow_rfx3 = grow_rfx1[m,],
                                      grow_rfx4 = grow_rfx1[m,],
                                      surv_rfx1 = surv_rfx1[m,],
                                      surv_rfx2 = surv_rfx1[m,],
                                      surv_rfx3 = surv_rfx1[m,],
                                      surv_rfx4 = surv_rfx1[m,],
                                      flow_rfx = flow_rfx[m,],
                                      repro_rfx = repro_rfx[m,],
                                      viab_rfx1 = viab_rfx1[m,],
                                      viab_rfx2 = viab_rfx1[m,],
                                      viab_rfx3 = viab_rfx1[m,],
                                      viab_rfx4 = viab_rfx1[m,],## viability model year rfx
                                      max_yrs = max_yrs,        ## the # years you want to iterate
                                      matsize=matsize,          ## size of transition matrix
                                      scenario = scenario[n],   ## partner diversity scenario
                                      lower=lower,upper=upper  )
  }
}
# Set the names of each column to the corresponding partner scenario and save the results as a csv
colnames(lams_stoch_null) <- scenario
write.csv(lams_stoch_null,"stoch_null_post_lambda.csv")
