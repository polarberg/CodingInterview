#%matplotlib inline 
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt 
plt.rcParams['figure.figsize'] = (20.0, 10.0) 

# Reading Data 
data = pd.read_csv('bottle.csv/bottle.csv')
print(data.shape) 
data.head()

# Collecting X and Y
X = data['Cst_Cnt'].values
Y = data['Btl_Cnt'].values

# Mean X and Y 
mean_x = np.mean(X)
mean_y = np.mean(Y)

# Total number of values
m = len(X)

# Using the formula to calculate b1 and b0 
numer = 0
denom = 0 
for i in range(m): 
    numer += (X[i] - mean_x) * (Y[i] - mean_y) 
    denom += (X[i] - mean_x) ** 2 
b1 = numer / denom 
b0 = mean_y - (b1 * mean_y)

# Print Coefficients 
print(b1, b0) 

print(data.shape)
# graphing
#plt.scatter(X, Y,  color='black')
""" plt.plot(X, Y, 'o')
plt.title('Test Data')
plt.xlabel('X')
plt.ylabel('Y')
plt.xticks(np.arange(min(X), max(X)+1, 1.0))
plt.xticks(())
plt.yticks(())

#best fit line 
plt.plot(X, b1*X)
plt.show() """

""" # R^2 Method
ss_t = 0
ss_r = 0 
for i in range(m): 
    y_pred = b0 + b1 * X[i]
    ss_t += (Y[i] - mean_y) ** 2
    ss_r += (Y[i] - y_pred) ** 2 
r2 = 1 - (ss_r/ss_t) 
print(r2) """