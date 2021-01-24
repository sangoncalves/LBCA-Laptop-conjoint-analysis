library(mlogit)
setwd('C:/Users/sande/Documents/MyProjects/LBCA-Laptop-conjoint-analysis')
laptops = read.csv('./dataset/laptops.csv', sep=";")

#information about the theory
{

#we do not have ratings in our dataset -> use Choice-based Conjoint Analysis

#goal: the aim of the data analysis is to assess the relationship between the choice and the product attributes.

#choice-based conjoint survey customers are asked to make choices among alternative products with differing characteristics and prices. In such a survey setting, since the results are not numbers but choices, they are analyzed using generalized linear models.

#The different product options proposed in the survey are typically called alternatives and the product characteristics are called attributes.

#The dataset is organized in the long format, where each row represents an alternative, relative to specific question answered by a specific respondent

#Since in this example each respondent can choose among 4 alternatives the dependent variable choice is, actually, a qualitative multinomial variable with 4 levels.

#A proper model to fit a variable of this kind is the Multinomial Logit Model, which is an extension of the binomial logit model to the case where the dependent variable has more than two levels.

#How do we check what is the order of the attributes? One alternative is to look at the order of the coeff of our model

#https://www.notion.so/sanmgo/Choice-based-conjoint-analysis-b134f078f00543c1910280c1fe1182fa
  }

#Analysing if the data is balanced
summary(laptops)
xtabs(choice ~ Price, data=laptops)
xtabs(choice ~ RAM, data=laptops)
xtabs(choice ~ Memory, data=laptops)
xtabs(choice ~ Processor, data=laptops)
xtabs(choice ~ Weight, data=laptops)
xtabs(choice ~ ScreenSize, data=laptops)

#Is our data balanced?? It seems that some attributes appears more than others

#reordering the attributes and converting it to qualitative. 
########Why we need them as qualitative?

laptops$Price       <- as.factor(laptops$Price)
laptops$RAM         <- factor(laptops$RAM, levels=c( "4GB", "8GB", "16GB", "32GB" ))
laptops$Memory      <- factor(laptops$Memory, levels=c( "126GB", "256GB", "512GB", "1T" ))
laptops$Processor   <- factor(laptops$Processor, levels=c( "i3", "i5", "i7", "i9" ))
laptops$Weight      <- factor(laptops$Weight, levels=c( "0.8kg", "1kg", "1.2kg", "1.5kg" ))
laptops$ScreenSize  <- as.factor(laptops$ScreenSize) 
laptops$alt         <- factor(laptops$alt, levels=c("1", "2", "3", "4")) # Not sure if we need to convert alt to qualitative


#Fitting model
laptops.mlogit <- dfidx(laptops, idx = list(c("ques", "resp.id"), "alt"), drop.index=F,levels=c(1,2,3,4))

#Creating alternatives for the models to be chosen (lm = laptop_model)
lm1 <- mlogit(choice ~ Price + RAM + Memory + Processor + Weight + ScreenSize, data = laptops.mlogit)
summary(lm1)

lm2 <- mlogit(choice ~ Price + RAM + Memory + Processor + Weight + ScreenSize | -1, data = laptops.mlogit)
summary(lm2)

lrtest(lm2, lm1) #compare the larger model with intercepts and the nested smaller model without them in order to identify if we can use the model without the intercepts to gain more precision. Slide 20. In our case p-value is 0.5133, if we use level of significance 0.05, then we do not have enough evidence to reject the null hypothesis, therefore the model can be seen as identical.

#Theory about the model
{
#The Estimate column provides the estimated average part worth for each level; they have to be interpreted with respect to the reference level of each attribute

#The order of magnitude of the estimates provides how strong the preferences are. MNL model coefficients are on the logit scale, they tend to range mainly between ???2 and 2

#The Std. Error column gives the level of precision of the estimates and is followed by the z-test statistics and associated p-value indicating the sample evidence against the null hypothesis that the coefficient is equal to zero.
  
#The estimated intercepts, that represent the so-called alternative specific   constants (asc), provide the preferences for the positions of the alternatives in each question 
  
# estimated alternative specific constants are not significantly different from zero-> consumers not choosing based on the location of the option
  
#If we find one of the intercepts to be significant, that may imply that some respondents chose the mid or the right option while disregarding the question.
  
}

#Analyze model with price as qualitative vs quantitative
lm3 <- mlogit(choice ~  as.numeric(as.character(Price)) + RAM + Memory + Processor + Weight + ScreenSize | -1, data = laptops.mlogit)
summary(lm3)
lrtest(lm3, lm2)

#since our p-value is smaller than our significance level(0.05), we cannot use price as quantitative variable. This means that we cannot analyze the willingness-to-pay for each level's attribute.

##Can we analyze the willingness-to-pay on each price????

###########We need to have attention regarding to the preference share! There are some restrictions in interpreting the results, need to check the related class video!
#it is important to not treat the obtained preference share predictions as actual market share forecasts. Indeed, while these predictions represent well the respondents behaviour in a survey context, they not necessarily translate to actual sales in the real marketplace.

#Considering the set of relevant designs vs all possible sets
attributes <- list(Price=names(table(laptops.mlogit$Price)),
                   RAM=names(table(laptops.mlogit$RAM)),
                   Memory=names(table(laptops.mlogit$Memory)),
                   Processor=names(table(laptops.mlogit$Processor)),
                   Weight=names(table(laptops.mlogit$Weight)),
                   ScreenSize=names(table(laptops.mlogit$ScreenSize)))
allDesign <- expand.grid(attributes) 
allDesign #all possible design

# In order to choose the designs, it is a good approach to remove the ones that are not feasible. High end features with lowest price for example. 

# we need to choose some designs to analyze, the possible combinations are too great, we need to reduce them in a meaningful way, like some for entry, mid and high end market.


ProductSelection <- function(Price,RAM,Memory,Processor,Weight,ScreenSize){
  ram <-  paste(as.character(RAM), "GB", sep = "")
  if(Memory==1) memory <- paste(as.character(Memory), "T", sep = "") else memory <-  paste(as.character(Memory), "GB", sep = "")
  processor <-  paste('i',as.character(Processor), sep = "")
  weight <-  paste(as.character(Weight), "kg", sep = "")
  
  return(filter(allDesign, Price == {{Price}}, RAM == {{ram}}, Memory == {{ memory }}, Processor == {{ processor }}, Weight == {{ weight }}, ScreenSize == {{ ScreenSize }}))
}


#Entry market
entry1 <- ProductSelection(Price = 0.7, RAM = 4,Memory = 126,Processor = 3, Weight = 0.8,ScreenSize = 12)
entry2 <- ProductSelection(Price = 1, RAM = 4,Memory = 126,Processor = 3, Weight = 1.2,ScreenSize = 13)

#Mid market
mid1 <- ProductSelection(Price = 1, RAM = 8,Memory = 256,Processor = 5, Weight = 1, ScreenSize = 13)
mid2 <- ProductSelection(Price = 1.5, RAM = 16,Memory = 512,Processor = 7, Weight = 1.5,ScreenSize = 16)

#High end market
high1 <- ProductSelection(Price = 2, RAM = 16,Memory = 512, Processor = 7, Weight = 1.2,ScreenSize = 16)
high2 <- ProductSelection(Price = 2, RAM = 32,Memory = 1, Processor = 9, Weight = 1.5,ScreenSize = 14)

profiles <- rbind(entry1, entry2, mid1, mid2, high1, high2)

predict.mnl <- function(model, data) {
  # Function for predicting preference shares from a MNL model 
  # model: mlogit object returned by mlogit()
  # data: a data frame containing the set of designs for which you want to 
  #       predict shares.  Same format at the data used to estimate model. 
  data.model <- model.matrix(update(model$formula, 0 ~ .), data = data)[,-1]
  logitUtility <- data.model%*%model$coef
  share <- exp(logitUtility)/sum(exp(logitUtility))
  cbind(share, data)
}


predict.mnl(lm2, profiles) # using m2 specification


getmode <- function(v) {
  uniqv <- unique(v) %>% select(colnames(laptops)-c("resp.id","qes", "alt"))
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

x <- getmode(laptops)

sensitivity.mnl <- function(model, attrib, base.data, competitor.data) {
  # Function for creating data for a preference share-sensitivity chart
  # model: mlogit object returned by mlogit() function
  # attrib: list of vectors with attribute levels to be used in sensitivity
  # base.data: data frame containing baseline design of target product
  # competitor.data: data frame contining design of competitive set
  data <- rbind(base.data, competitor.data)
  base.share <- predict.mnl(model, data)[1,1]
  share <- NULL
  for (a in seq_along(attrib)) {
    for (i in attrib[[a]]) {
      data[1,] <- base.data
      data[1,a] <- i
      share <- c(share, predict.mnl(model, data)[1,1])
    }
  }
  data.frame(level=unlist(attrib), share=share, increase=share-base.share)
}
base.data <- profiles[5,]
competitor.data <- profiles[-5,]
tradeoff <- sensitivity.mnl(lm2, attributes, base.data, competitor.data)

barplot(tradeoff$increase, horiz=FALSE, names.arg=tradeoff$level,
        ylab="Change in Share for the Planned Product Design", 
        ylim=c(-0.1,0.4))
grid(nx=NA, ny=NULL)


#heterogeneity

lm2.rpar <- rep("n", length=length(lm2$coef))
names(lm2.rpar) <- names(lm2$coef)
lm2.rpar



lm2.mixed <- mlogit(choice ~ Price + RAM + Memory + Processor + Weight + ScreenSize  | -1, 
                   data = laptops.mlogit, 
                   panel=TRUE, rpar = lm2.rpar, correlation = FALSE)
summary(lm2.mixed)

# We can get a visual summary of the distribution of random effects and hence of the level of heterogeneity
layout(matrix(c(3,3,2,3), 2, 2, byrow = TRUE))
#par(mfrow=c(2,2))
plot(lm2.mixed)

#comparing the sign of the quantiles we can identify that Processori5 and Weight1.5kg have different signs, which could imply into heterogeneity
par(mfrow=c(2,2))
processor5.distr <- rpar(lm2.mixed, "Processori5")
summary(processor5.distr)
mean(processor5.distr)
med(processor5.distr)
plot(processor5.distr)


Weight1.5kg.distr <- rpar(lm2.mixed, "Weight1.5kg")
summary(Weight1.5kg.distr)
mean(Weight1.5kg.distr)
med(Weight1.5kg.distr)
plot(Weight1.5kg.distr)

#High significance means 3*
lm2.mixed2 <- update(lm2.mixed, correlation = TRUE)
summary(lm2.mixed2)

cov2cor(cov.mlogit(lm2.mixed2))

summary(vcov(lm2.mixed2, what = "rpar", type = "cor"))

lm2.mixed3 <- update(lm2.mixed2, correlation = c("Price1.5", "RAM8GB","RAM16GB", "RAM32GB", "Memory256GB","Memory512GB", "Memory1T", "Processori5", "Processori7","Processori9", "Weight1kg", "Weight1.2kg", "Weight1.5kg", "ScreenSize13", "ScreenSize14", "ScreenSize16"))

# The significant presence of random coefficients and their correlation 
# can be further investigated using the ML tests, such as the ML ratio test
lrtest(lm2, lm2.mixed) #Fixed effects vs. uncorrelated random effects
lrtest(lm2.mixed, lm2.mixed2) #Uncorrelated random effects vs. all correlated random effects
lrtest(lm2.mixed3, lm2.mixed2) #partially correlated random effects vs. all correlated random effects
