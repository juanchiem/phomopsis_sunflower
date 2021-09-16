
## -----------------------------------------------------------------------------
library("DClusterm")
data(brainNM)


## ----label = "SMRNM", fig = TRUE, echo = FALSE, fig.cap = "Standardized Mortality Ratio (SMR) of brain cancer in New Mexico from 1973 to 1991."----
library("viridis")
library("spacetime")

#Create discrete variable for plotting
splitvalues <- function(xx) {
  res <- cut(xx, c(0, 0.5, 0.8, 1.0, 1.2, 1.5, Inf), include.lowest = TRUE)
  levels(res) <- c("0.0 - 0.5", "0.5 - 0.8", "0.8 - 1.0", "1.0 - 1.2",
     "1.2 - 1.5", "1.5+")
  return(res)
}

brainst@data$SMRcat <- splitvalues(brainst@data$SMR)

stplot(brainst[, , "SMRcat"], col.regions = hcl.colors(6, "Blue-Red"),
  names.attr = 1973:1991, 
  main = "Standardized mortality ratio")

## -----------------------------------------------------------------------------
nm.adj <- poly2nb(brainst@sp)
adj.mat <- as(nb2mat(nm.adj, style = "B"), "Matrix")

## -----------------------------------------------------------------------------
# Prior of precision
prec.prior <- list(prec = list(param = c(0.001, 0.001)))

brain.st <- inla(Observed ~ 1 + f(Year, model = "rw1",
      hyper = prec.prior) + 
    f(as.numeric(ID), model = "besag", graph = adj.mat,
      hyper = prec.prior),
  data = brainst@data, E = Expected, family = "poisson",
  control.predictor = list(compute = TRUE, link = 1))
summary(brain.st)


## ----label = "brainRR", fig = TRUE, echo = FALSE, fig.cap = '(ref:brainRR)'----
brainst@data$RR <- brain.st$summary.fitted.values[ , "mean"] 

#brainst@data$RRcat <- splitvalues(brainst@data$RR)
stplot(brainst[, , "RR"], col.regions = rev(magma(32)), 
  names.attr = 1973:1991, at = seq(0.75, 1.25, length.out = 32),
  main = "Relative risk estimates")


## -----------------------------------------------------------------------------
names(inla.models()$group)


## -----------------------------------------------------------------------------
brainst@data$ID.Year <- brainst@data$Year - 1973 + 1
brainst@data$ID2 <- brainst@data$ID


## -----------------------------------------------------------------------------
brain.st2 <- inla(Observed ~ 1 + 
    f(as.numeric(ID2), model = "besag", graph = adj.mat,
      group = ID.Year, control.group = list(model = "ar1"),
        hyper = prec.prior),
  data = brainst@data, E = Expected, family = "poisson",
  control.predictor = list(compute = TRUE, link = 1))
summary(brain.st2)


## ----fig = TRUE, label = "braingroup", echo = FALSE, fig.cap = '(ref:braingroup)'----
brainst@data$RRgroup <- brain.st2$summary.fitted.values[ , "mean"]

#brainst@data$RRgroupcat <- splitvalues(brainst@data$RRgroup)
stplot(brainst[, , "RRgroup"], col.regions = rev(magma(32)),
  names.attr = 1973:1991, at = seq(0.75, 1.25, length.out = 32),
  main = "Relative risk estimates")

