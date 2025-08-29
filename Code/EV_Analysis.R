---
title: "EV Analysis"
author: "Uchenna Ekeh"
date: "2023-12-29"
output: html_document
---


```{r Load}
data<-read.csv("ElectricCarData_Norm.csv")
apply(data, 2, function(x) sum(is.na(x)))
```

Here we want to see what the data is like

```{r summarise}
data <- na.omit(data)
summary(data)
head(data)
```


This is the Cleaning and Transforming Portion of the Data
We see that each of the predictors except Seats and Price Euro are categorical. We want to convert several of these columns to numeric
There are several empty values that need to be changed to null



```{r }
library(dplyr)

cols_to_clean <- c("Accel","TopSpeed", "Range", "Efficiency", "FastCharge")

data <- data %>%
  mutate(across(all_of(cols_to_clean), ~ as.numeric(gsub("[^0-9.]", "", .))))


data$Brand <- NULL
data$Model <- NULL
data$FastCharge[data$FastCharge == '-'] <- '0'
data$FastCharge <- as.numeric(ifelse(data$FastCharge == '-', 0, data$FastCharge))
data$RapidCharge <- ifelse(data$RapidCharge == "Rapid charging possible", "Y", "N")

data$PowerTrain <- ifelse(data$PowerTrain == 'All Wheel Drive', "AWD", data$PowerTrain)
data$PowerTrain <- (ifelse(data$PowerTrain == 'Rear Wheel Drive', "RWD", data$PowerTrain))
data$PowerTrain <-(ifelse(data$PowerTrain == 'Front Wheel Drive', "FWD", data$PowerTrain))
```

```{r}
summary(data)
data$PowerTrain
```

```{r}
cat("Rapid Charge: ")
table(data$RapidCharge)

cat("\nPower Train: ")
table(data$PowerTrain)

cat("\nPlug Type:")
table(data$PlugType)

cat("\nBody Style:")
table(data$BodyStyle)

cat("\nSegment:")
table(data$Segment)
```

```{r}
subset(data, Segment=='S')
```

```{r}
attach(data)
library(ggplot2)
par(mfrow=c(2,3))
hist(PriceEuro,main="Distribution of Prices")
hist(Accel,main="Distribution of Accelerations",xlab="Acceleration in sec. to go 0 to 100 Km/H")
hist(TopSpeed,main="Distribution of Top Speeds")
hist(Range,main="Distribution of Ranges")
hist(Efficiency,main="Distribution of Efficiency")
hist(FastCharge,main="Distribution of Fast Charge")
```

```{r }
par(mfrow=c(1,2))
boxplot(Range~PowerTrain, main="Range Distribution by Power Train Type", xlab="Power Train", col="blue", border="black")
boxplot(Accel~PowerTrain, main="Acceleration Distribution by Power Train Type", xlab="Power Train", ylab="Acceleration (0 to 100 Km/H)", col="blue", border="black")
boxplot(TopSpeed~PowerTrain, main="Top Speed Distribution by Power Train Type", xlab="Power Train", col="blue", border="black")
boxplot(PriceEuro~PowerTrain, main="Price Distribution by Power Train Type", xlab="Power Train", col="blue", border="black")
```

```{r}
cor_matrix <- cor(data[, sapply(data, is.numeric)])
cor_matrix

variable_names<-c("Accel","TopSpeed","Range","Efficiency","Seats","PriceEuro","FastCharge")
colors <- colorRampPalette(c("blue", "white", "red"))(100)

image(1:ncol(cor_matrix), 1:ncol(cor_matrix), cor_matrix, axes = FALSE, col=colors,  main="Correlation Matrix Heatmap")
axis(1, at=1:ncol(cor_matrix), labels=variable_names, font =.1)
axis(2, at=1:ncol(cor_matrix), labels=variable_names)
```

```{r}
library(car)
model <- lm(PriceEuro~Accel+TopSpeed+Range+Efficiency+Seats+FastCharge,data=data)
vif_values <- vif(model)
print(vif_values)

```



```{r}
#car_data <- read.csv("ElectricCarData_Clean.csv")
#car_data$FastCharge <- as.numeric(car_data$FastCharge, errors = "na")
car_data_clean <- na.omit(data)
model <- lm(PriceEuro ~ Accel + TopSpeed + Range + Efficiency + FastCharge + Seats + PowerTrain, car_data_clean ) 
#= car_data_clean
summary(model)
```
```{r}
plot(model, which=1, main="Residuals vs Fitted", sub = "")
plot(model, which=2, main="QQPlot", sub = "")

```


```{r}
model_reduced <- lm(PriceEuro ~ TopSpeed + Range + Efficiency + Seats, data = car_data_clean)
summary(model_reduced)
```
                  
```{r}
anova(model, model_reduced)
AIC(model, model_reduced)
BIC(model, model_reduced)
```

```{r}
new_obs <- data.frame(Accel = mean(car_data_clean$Accel),
                      TopSpeed = mean(car_data_clean$TopSpeed),
                      Range = mean(car_data_clean$Range),
                      Efficiency = mean(car_data_clean$Efficiency),
                      FastCharge = mean(car_data_clean$FastCharge),
                      Seats = mean(car_data_clean$Seats),
                      PowerTrain = "AWD")

predict(model, newdata = new_obs, interval = "prediction")

# For Reduced Model
new_obs_reduced <- data.frame(TopSpeed = mean(car_data_clean$TopSpeed),
                              Range = mean(car_data_clean$Range),
                              Efficiency = mean(car_data_clean$Efficiency),
                              Seats = mean(car_data_clean$Seats))

predict(model_reduced, newdata = new_obs_reduced, interval = "prediction")
```

```{r}

y <- car_data_clean$PriceEuro
df2 <- car_data_clean
df2$PowerTrain

car_data_clean$Accel
car_data_clean$Range
car_data_clean$TopSpeed
car_data_clean$Seats
car_data_clean$Efficiency
car_data_clean$PowerTrain
data["PowerTrain"][data["PowerTrain"] == "AWD"] <- as.double(0)
data["PowerTrain"][data["PowerTrain"] == "RWD"] <- as.double(-15435.17)
data["PowerTrain"][data["PowerTrain"] == "FWD"] <- as.double(-10754.97)
print(data$PowerTrain)

as.double(4)
x1 <- data$Accel
x2 <- data$Range
x3 <- data$TopSpeed
x4 <- data$Seats
x5 <- data$Efficiency
x6 <- as.double(data$PowerTrain)
length(x1)
length(x2)
length(x3)
length(x4)
length(x5)
length(x6)
data[17,]
data <- data[-c(17, 49, 73) ]
data

```

```{r}
#Penalize Regression - Ridge Regression
#Ridge Regression
#You will need to read in the file from your computer.
#BF <- read.csv(FILL IN, sep="")
library(glmnet)
y<-data$PriceEuro

x1 <- data$Accel
x2 <- data$Range
x3 <- data$TopSpeed
x4 <- data$Seats
x5 <- data$Efficiency
x6 <- as.double(data$PowerTrain)

#setting up the data for Ridge Regression
u<-y-mean(y)
z1<-scale(x1)
z2<-scale(x2)
z3<-scale(x3)
z4<-scale(x4)
z5<-scale(x5)
z6<-scale(x6)
library(genridge)
c_range<-seq(0.000,1,0.0001)
y<-u
X<-data.frame(z1,z2,z3,z4,z5,z6)
X<-as.matrix(X)
fit_ridge<-ridge(y,X,lambda=c_range)
traceplot(fit_ridge,cex=0.5)
fit_ridge
#For t=0.3
fit_ridge_t<-ridge(y,X,lambda=0.3)
typeof(fit_ridge_t)
fit_ridge_t2<-ridge(u~z1+z2+z3+z4+z5+z6,lambda=0.3)
coef(fit_ridge_t2)
#vif(fit_ridge_t)

#VIF Value Analysis
c_range<-seq(0.000,1,0.01)
y<-u
X<-data.frame(z1,z2,z3,z4,z5,z6)
X<-as.matrix(X)
fit_ridge<-ridge(y,X,lambda=c_range)
vridge<-vif(fit_ridge)
(vridge<-as.data.frame(vridge))

#For t=0.12
fit_ridge_t2<-ridge(u~z1+z2+z3+z4+z5+z6,lambda=0.12)
coef(fit_ridge_t2)




```