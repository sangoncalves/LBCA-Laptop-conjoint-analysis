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
#summary(l1)

lm2 <- mlogit(choice ~ Price + RAM + Memory + Processor + Weight + ScreenSize | -1, data = laptops.mlogit)
#summary(l2)

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
  laptops %>% filter(laptops, Price == {{ Price }}, RAM == {{ RAM }}+"GB", Memory == {{ Memory }}, Processor == {{ Processor }}, Weight == {{ Weight }}, ScreenSize == {{ ScreenSize }})
}

#Entry market
ProductSelection <- function(Price,RAM,Memory,Processor,Weight,ScreenSize){
  ram = paste(as.character(RAM), "GB", sep = "")
  memory = paste(as.character(Memory), "GB", sep = "")
  processor = paste('i',as.character(Processor), sep = "")
  weight = paste(as.character(Weight), "kg", sep = "")
  return(filter(laptops, Price == {{Price}}, RAM == {{ram}}, Memory == {{ memory }}, Processor == {{ processor }}, Weight == {{ weight }}, ScreenSize == {{ ScreenSize }}))
}


entry1 <- ProductSelection(Price = 1,RAM = 4,Memory = 126,Processor = 3, Weight = 1.2,ScreenSize = 12)

entry2 <- ProductSelection(Price = 0.7,RAM = 4,Memory = 126,Processor = 3, Weight = 1.5,ScreenSize = 12)
