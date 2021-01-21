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

#https://www.notion.so/sanmgo/Choice-based-conjoint-analysis-b134f078f00543c1910280c1fe1182fa
  }

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

laptops$Price <- as.factor(laptops$Price)
#laptops$Price <- factor(laptops$Price, levels=c("0.7", "1", "1.5", "2")) not sure if we need to add levels for this
laptops$RAM <- factor(laptops$RAM, levels=c( "4BG", "8GB", "16GB", "32GB" ))
laptops$Memory <- factor(laptops$Memory, levels=c( "126GB", "256GB", "512GB", "1T" ))
laptops$Processor <- factor(laptops$Processor, levels=c( "i3", "i5", "i7", "i9" ))
laptops$Weight <- factor(laptops$Weight, levels=c( "0.8kg", "1kg", "1.2kg", "1.5kg" ))
laptops$ScreenSize <- factor(laptops$ScreenSize) 
#laptops$ScreenSize <- factor(laptops$ScreenSize, levels=c("12","13","14", "16"))  not sure if we need to add levels for this
laptops$alt <- as.factor(laptops$alt) # Not sure if we need to convert alt...

#How do we check what is the order of the attributes?

#Fitting model
#laptops.mlogit <- dfidx(laptops, idx = list(c("ques", "resp.id"), "alt"), drop.index=F,levels=c("1", "2", "3","4")) #It was the same...
laptops.mlogit <- dfidx(laptops, idx = list(c("ques", "resp.id"), "alt"), drop.index=F,levels=c(1,2,3,4))

l1 <- mlogit(choice ~ Price + RAM + Memory + Processor + Weight + ScreenSize, data = laptops.mlogit)
summary(l1)

l2 <- mlogit(choice ~ Price + RAM + Memory + Processor + Weight + ScreenSize | -1, data = laptops.mlogit)
summary(l2)