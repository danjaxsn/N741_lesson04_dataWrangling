# Data Wrangling
#
# everything in R is an object
#
# perform simple math
# output sent to console
5 + 10

# technically this value is saved in memory
# you can recall it using last vale
.Last.value

# save the result of the addition
# as an object named x
x <- 5 + 10

# now x shows up in Global Environment
# recall x
x

# use x in a computation
# save the result as y
y <- x*x

# create an object with multiple values
# the c() function concatenates values together
# into a vector
# these can be numeric
a <- c(1,2,3,4,5)

# inspect a
class(a)
is.numeric(a)
is.vector(a)

# we can also have character and logical
b <- c("egg","milk","bread","cheese","meat")
c <- c(FALSE, FALSE, TRUE, FALSE, TRUE)

class(b)
class(c)
is.character(b)
is.logical(c)

# some types can be coerced to other types
as.numeric(c)
as.character(a)

# logical variables are neat
# they are both logical and numerical
# we can sum up the number of trues
sum(c)

# and find the percent of true
mean(c) * 100

# create another numeric vector
a2 <- c(6,7,8,9,10)

# vectors of the same type can be
# combined to form matrices
# if they are the same length
# note A and a are different objects in R
# R is CaSe sEnsiTive
A <- cbind(a, a2)
class(A)
is.numeric(A)
is.matrix(A)

# we can also combine vectors of different types
# but same length to form data.frame's
df <- data.frame(a,b,c)
class(df)

# what happens if we use cbind() 
# instead of data.frame() here??

# data.frame's are the workhorse of R
# you can view the data and sort it in the viewer
# and won't change any of the data

# another type of variable that can be useful
# is a factor which is both numeric and categorical sort of
# create another numeric vector
d <- c(1,2,3,2,3)

# add it to the data.frame
df <- data.frame(df,d)

# inspect the class of d in df
# use $ selector to select d from df
class(df$d)

# see a frequency table of the values in d
table(df$d)

# we can run a sum of the values in d
# since the values are numeric
sum(df$d)

# convert d to a factor
# define the levels and labels
# like the "variable view" in SPSS
# or FORMATS in SAS
df$d <- factor(df$d,
               levels = c(1,2,3),
               labels = c("red","green","blue"))

# now view d in df
# check the class of d in df
# and get a summary table of frequencies
df$d
class(df$d)
table(df$d)

# even though the values in d are numbers
# we can't now get a sum
sum(df$d)

# but we can coerce it back to numeric
# and then run the sum
# notice the nested functions
sum(as.numeric(df$d))

# see help(sum)
help(sum)
# most common error in R
# class type mismatch

# let's load some data and explore it

# ==========================
# install these packages
#    gapminder
#    dplyr
#    ggplot2
#    ggthemes

# load gapminder package
library(gapminder)

# get a list of the datasets included
# with the gapminder package
data(package = "gapminder")

# list the names of the variables
# or columns in the gapminder dataset

names(gapminder)

# view the gapminder dataset
View(gapminder)

# look at the structure of the variables
# in gapminder dataset - lists the type or class
# of each variable
str(gapminder)

# get summary stats for the variables
# in the gapminder dataset
summary(gapminder)

# load dplyr package
# to get useful functions for data wrangling
# and to use the pipe %>% syntax approach
library(dplyr)

# use the gapminder dataset
# then pull out 1 variable pop
# then run the mean function (get the mean)
gapminder %>%
  pull(pop) %>%
  mean()

# "old" way with "base" R approach
# use $ selector to get the pop
# variable - put inside as argument
# to the mean function
mean(gapminder$pop)

# use the gapminder dataset
# then select multiple variables (2 or more)
# then get summary stats of these selected variables
gapminder %>%
  select(lifeExp, gdpPercap) %>%
  summary()

# we can't use the mean function
# but we can use the colMeans() function
gapminder %>%
  select(lifeExp, gdpPercap) %>%
  colMeans()

# get a list of the years included
# base R approach
table(gapminder$year)

# dplyr pipe %>% approach
gapminder %>%
  pull(year) %>%
  table()

# select rows that match year 1982
# use double equals to test for logic
# get summary stats for data from 1982
gapminder %>%
  filter(year == 1982) %>%
  summary()

# select rows 1 to 100
# and get summary stats
gapminder %>%
  slice(1:100) %>%
  summary()

# another way to get summary stats for specific stats
# across multiple variables
# use summarise function from dplyr
gapminder %>%
  summarise(meanLE = mean(lifeExp), 
            meanGDP = mean(gdpPercap))

# we can also use group_by() from dplyr
# to get stats by other grouping variable
# such as continent
gapminder %>%
  group_by(continent) %>%
  summarise(meanLE = mean(lifeExp), 
            meanGDP = mean(gdpPercap))

# NOTE: This will give you an error
# the colMeans() function wants a data.frame
gapminder %>%
  group_by(continent) %>%
  select(lifeExp, gdpPercap) %>%
  colMeans()

# the group_by() function creates
# a special type of data.frame
# which we can see by running the class() function
gapminder %>%
  group_by(continent) %>%
  class()

# however, we can also use the aggregate
# function (from base R) to get lifeExp means
# by continent without having to use dplyr::group_by()
aggregate(formula = lifeExp ~ continent, 
          data = gapminder,
          FUN = mean)

# let's "save" the gapminder dataset
# as a new object (make a copy) to Global Environment
gm <- gapminder

# see class of gm object (dataset)
class(gm)

# get the dimensions (rows and columns) of gm
dim(gm)

# use the mutate() function from dplyr
# to create and add a new variable
# assign gm to gm <- 
# then create new variable, new column
# gdp equal to gdpPercap * pop
# notice that 1 column is added to gm
gm <- gm %>% 
  mutate(gdp = pop * gdpPercap)

# get summary stats of updated dataset
summary(gm)

# plot a histogram of gdp
hist(gm$gdp)

# ggplot2 approach to plotting
# load the ggplot2 package
library(ggplot2)

# use ggplot() function to layout graphics environment
# define dataset and aesthetics (variables to use in plot)
ggplot(data = gm, aes(x = gdp)) 

# next add + a geom, geometric object
# for histogram, which is geom_histogram()
ggplot(data = gm, aes(x = gdp)) +
  geom_histogram()

# let's clean up the plot 
# applyt the natural log transform and replot
# note nested functions
hist(log(gm$gdp))

# same plot for log(gdp) using ggplot
ggplot(data = gm, aes(log(gdp))) +
  geom_histogram()

# add better labels, a title and colors
# color defines the lines for each histogram bin
# fill defines the colors inside each bin
ggplot(data = gm, aes(log(gdp))) +
  geom_histogram(color = "black", fill = "blue") +
  xlab("log(GDP)") +
  ylab("Frequencies") +
  ggtitle("Histogram of GDP (natural log scale)")

# we can tweak the "theme" of the plot
# by adding a grid using theme_linedraw()
ggplot(data = gm, aes(log(gdp))) +
  geom_histogram(color = "black", fill = "blue") +
  xlab("log(GDP)") +
  ylab("Frequencies") +
  ggtitle("Histogram of GDP (natural log scale)") +
  theme_linedraw()

# let's have some fun - load
# the ggthemes package
library(ggthemes)

# now change the theme to one that looks like
# it was published in the WSJ (Wall Street Journal)
ggplot(data = gm, aes(log(gdp))) +
  geom_histogram(color = "black", fill = "blue") +
  xlab("log(GDP)") +
  ylab("Frequencies") +
  ggtitle("Histogram of GDP (natural log scale)") +
  theme_wsj()

# try one that will look like it was published
# in the Economist
ggplot(data = gm, aes(log(gdp))) +
  geom_histogram(color = "black", fill = "blue") +
  xlab("log(GDP)") +
  ylab("Frequencies") +
  ggtitle("Histogram of GDP (natural log scale)") +
  theme_economist()

