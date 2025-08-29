

# Electric Vehicle Market Analysis 🚗⚡
This project analyzes a dataset of electric vehicles to uncover factors influencing their price and performance. Using a dataset of electric cars, we explore relationships between various attributes, build predictive models, and diagnose their effectiveness.

### The Data
Our analysis is based on the ElectricCarData_Norm.csv dataset. The data includes key specifications for electric cars, such as:

- __Vehicle Information:__ Brand, Model, Plug Type, Body Style, and Segment.

- __Performance Metrics:__ Acceleration (Accel), Top Speed (TopSpeed), and Range (Range).

- __Charging & Efficiency:__ Efficiency and Fast Charge (FastCharge), along with a boolean indicator for Rapid Charge (RapidCharge).

- __Other Features:__ Number of Seats (Seats) and Price in Euro (PriceEuro), our main response variable.

### Data Cleaning and Transformation
The initial data contained character-based units (e.g., "sec" in Accel) and inconsistent categorical values. Our cleaning process involved:

- Converting key performance columns (Accel, TopSpeed, Range, Efficiency, FastCharge) from character strings to numeric values.

- Standardizing categorical variables like PowerTrain and RapidCharge to have consistent, simplified labels (AWD, RWD, FWD, and Y/N).

- Removing irrelevant variables like Brand and Model and handling missing values by omitting rows with NA.

### Data Exploration and Visualizations
We created several visualizations to understand the dataset's structure:

- Histograms: These plots show the distribution of key numeric variables like Price, Acceleration, and Range, revealing their central tendencies and spread.

- Boxplots: Boxplots of variables like Range and Acceleration were plotted against PowerTrain to visualize how different powertrains affect performance.

- Correlation Heatmap: This heatmap displays the relationships between all numeric variables, helping us to identify which factors are most correlated with PriceEuro.

### Predictive Modeling and Diagnostics
The core of our analysis involves building a linear model to predict an electric car's price.

- __Initial Model:__ We created a linear regression model (model) using all cleaned numeric and transformed categorical variables to predict PriceEuro.

- __Multicollinearity Check:__ We used VIF (Variance Inflation Factor) to check for multicollinearity among the predictors, which is a key assumption for linear regression.

- __Model Diagnostics:__ We used diagnostic plots to check our model's assumptions:

  - A Residuals vs. Fitted plot shows if the residuals are randomly scattered.

  - A Q-Q plot assesses if the residuals are normally distributed.

- Reduced Model: We built a second, reduced model based on a variable selection process to see if a simpler model could perform just as well.

- Model Comparison: We used ANOVA, AIC, and BIC to compare the full model against the reduced model to determine which provides the best fit and parsimony.

### Advanced Methods
 We also explored penalized regression with Ridge Regression to handle potential multicollinearity and overfitting. We used a trace plot to visualize how coefficients shrink as the penalty parameter (lambda) increases. VIF values for the ridge regression were also analyzed to see how the technique reduced multicollinearity.

### Conclusion and Future Work
Our analysis provides insights into the factors that influence the price of electric vehicles. The models allow for price prediction based on a car's specifications. The diagnostic plots, however, reveal some violations of linear model assumptions, suggesting that more complex models may be needed. Further work could involve exploring other modeling techniques or collecting more data to improve the model's accuracy.
