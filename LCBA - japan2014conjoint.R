library(cjoint)
library(hash) #https://stackoverflow.com/questions/7818970/is-there-a-dictionary-functionality-in-r/44570412
data("japan2014conjoint")
data <- japan2014conjoint



keys <- list('respondent','respondentIndex','task','profile','selected','Consumption tax','Consumption tax.rowpos
','Employment','Employment.rowpos','Monetary and fiscal policy', 'Monetary and fiscal policy.rowpos','Economic growth strategy', 'Economic growth strategy.rowpos','Nuclear power', 'Nuclear power.rowpos','TPP','TPP.rowpos','Collective self-defense', 'Collective self-defense.rowpos','Constitutional revision','Constitutional revision.rowpos','National assembly seat reduction','National assembly seat reduction.rowpos','wgt')

values <- list('a character vector uniquely identifying the respondent','a numeric vector uniquely indexing the respondent','a numeric vector indexing the task presented to the respondent','a numeric vector indexing the profile presented to the respondent','a numeric vector indicating whether the profile was selected', 'a factor indicating the profile position on `Consumption Tax`', 'a numeric vector indicating which row the attribute `Consumption Tax` appeared in the given profile','a factor indicating the profile position on `Employment`','a numeric vector indicating which row the attribute `Employment` appeared in the given profile','a factor indicating the profile position on `Monetary and Fiscal Policy`', 'a numeric vector indicating which row the attribute `Monetary and Fiscal Policy` appeared in the given profile', 'a factor indicating the profile position on `Economic Growth Strategy`', 'a factor indicating which row the attribute `Economic Growth Strategy` appeared in the given profile', 'a factor indicating the profile position on `Nuclear Power`', 'a factor indicating which row the attribute `Nuclear Power` appeared in the given profile','a factor indicating the profile position on `Trans-Pacific Partnership (TPP)`', 'a factor indicating which row the attribute `Trans-Pacific Partnership (TPP)` appeared in the given profile','a factor indicating which row the attribute `Collective Self-Defense` appeared in the given profile','a factor indicating which row the attribute `Collective Self-Defense` appeared in the given profile','a factor indicating the profile position on `Constitutional Revision`','a factor indicating which row the attribute `Constitutional Revision` appeared in the given profile','a factor indicating the profile position on `National Assembly Seat Reduction`','a factor indicating which row the attribute `National Assembly Seat Reduction` appeared in the given profile', 'post-stratification weights to map the survey sample to the census population')

data.info <- hash() #structure similar to dictinary

for (item_position in (1:length(keys))){
  data.info[keys[item_position]] <- values[item_position]}


# print(data.info)
print(keys(data.info))
# print(values(data.info))
# print(data.info$Format)
str(data)
