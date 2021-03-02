# Project: Conjoint Analysis

This project was done on the course "Laboratory of Customer and Business Analytics" from University of Trento. The idea is that a generated dataset will be given and is necessary to draw conclusions that enhances business decision making.

This is a summary of the report. The html of the full report can be found on this [link](https://sangoncalves.github.io/Laptop-conjoint-analysis/).

# Objective

Analyse the given dataset and generate insigths for decision making having in mind a profile's laptop (defined set of features).

# Data

Generate by the professor of the course. Consists in choice-based survey, where the respondents needed to choose one laptop profile from three alternatives.
* Each respondent answered ### questions
*  There was ### respondents
*  There was ### profiles

# Profile Scenario

Profile 1: Selected profile
The other profiles are competitors

| Profile | Price (x1000€) | RAM | Memory | Processor | Weight | ScreenSize |
|--|-----|-----|--------|-----------| ------ |----------- |
| **1** | **1** | **8GB** | **256GB** | **i5** | **1kg** | **13** |
| 2 | 0.7  | 4GB | 126GB | i3 | 0.8kg | 12 |
 | 3 |  1 | 4GB | 126GB | i3 | 1.2kg | 13 |
 | 4 | 0.7 | 8GB | 126GB | i3 | 1.2kg | 14 |
| 5 | 0.7 | 8GB | 1T | i3 | 1.2kg | 16 |
 | 6 | 1.5 | 16GB |512GB|i7 | 1.5kg | 16 |
 | 7 | 0.7 | 4GB  | 126GB | i5 | 1.2kg | 14 |
 | 8 | 2 | 16GB  | 512GB | i7 | 1.2kg | 16 |
 | 9 | 2 | 32GB  | 1T | i9 | 1.5kg | 14 |
 | 10 | 0.7 | 4GB | 1T | i9 | 1kg | 16 |

# Models Analysed

Add here the set of models analysed. Add the chosen model.

# Preference Share 

| Profile | share |
| ------ |----------- |
| **1** | **0.019110330** |
| 2 | 0.004386443 |
| 3 | 0.022159508 |
| 4 | 0.195533286 |
| 5 | 0.589102805 |
| 6 | 0.002365335 |
| 7 | 0.093923556 |
| 8 | 0.004933601 |
| 9 | 0.003986239 | 
| 10 | 0.064498897 |

# Trade-off Features

|         |    level    |   share    | increase |
| ------ |----------- |----------- | ----------- |
|Price1      |   0.7 | 0.029542219 |  0.010431890|
|Price2      |     1 | 0.019110330 |  0.000000000|
|Price3      |   1.5 | 0.016896592 | -0.002213738|
|Price4      |     2 | 0.011599503 | -0.007510826|
|RAM1        |   4GB | 0.007674851 | -0.011435478|
|RAM2        |   8GB | 0.019110330 |  0.000000000|
|RAM3        |  16GB | 0.003865238 | -0.015245092|
|RAM4        |  32GB | 0.003419110 | -0.015691220|
|Memory1     | 126GB | 0.054675411 |  0.035565082|
|Memory2     | 256GB | 0.019110330 |  0.000000000|
|Memory3     | 512GB | 0.020777229 |  0.001666899|
|Memory4     |    1T | 0.139103221 |  0.119992891|
|Processor1  |    i3 | 0.015846199 | -0.003264131|
|Processor2  |    i5 | 0.019110330 |  0.000000000|
|Processor3  |    i7 | 0.013197605 | -0.005912724|
|Processor4  |    i9 | 0.005259109 | -0.013851221|
|Weight1     | 0.8kg | 0.008960730 | -0.010149599|
|Weight2     |   1kg | 0.019110330 |  0.000000000|
|Weight3     | 1.2kg | 0.022669210 |  0.003558880|
|Weight4     | 1.5kg | 0.007536066 | -0.011574264|
|ScreenSize1 |    12 | 0.006291918 | -0.012818411|
|ScreenSize2 |    13 | 0.019110330 |  0.000000000|
|ScreenSize3 |    14 | 0.041849643 |  0.022739313|
| ScreenSize4 |   16 | 0.044984600 | 0.025874270 |


# Proposed Profile Changes

|   |colMeans(shares) |Price  |RAM |Memory |Processor |Weight |ScreenSize|
|---| ----------- | ----------- | --- | ---- | -------- | ----------- |---|
|**1**  |     **0.163394122** |  **1.5**  |**8GB** |    **1T** |       **i5** |   **1kg** |        **13**|
|2  |     0.001516895 |  0.7  |4GB | 126GB |       i3 | 0.8kg |        12|
|3  |     0.008854438 |    1  |4GB | 126GB |       i3 | 1.2kg |        13|
|4  |     0.163650758 |  0.7  |8GB | 126GB |       i3 | 1.2kg |        14|
|5  |     0.530649505 |  0.7  |8GB |    1T |       i3 | 1.2kg |        16|
|6  |     0.001164504 |  1.5 1|6GB | 512GB |       i7 | 1.5kg |        16|
|7  |     0.071025080 |  0.7  |4GB | 126GB |       i5 | 1.2kg |        14|
|8  |     0.001641228 |    2 1|6GB | 512GB |       i7 | 1.2kg |        16|
|9  |     0.001939126 |    2 3|2GB |    1T |       i9 | 1.5kg |        14|
|10 |     0.056164342 |  0.7  |4GB |    1T |       i9 |   1kg |        16|
# Conclusion

One of the strategies that we could persue, if our production cost allows, is to increase the price from 1K to 1.5K and increase the memory from 256GB to 1T. If we use this strategy we could have a significant increase of preference share which nulifies the effect of the price increment on it. In this case, the preference share will change from ~1.5% to 16%.
