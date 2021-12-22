#Roger Gomez Nieto
# email: rogergomez@ieee.org
# Date:

#Se hace una regresion using a decision tree

#loading Libraries
import numpy as np
from sklearn.datasets import load_boston
from sklearn import tree
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split
from sklearn.model_selection import KFold
#loading data
boston_dataset = load_boston()
X,y = boston_dataset.data, boston_dataset.target
features = boston_dataset.feature_names

#defining the regressor parameters
regression_tree = tree.DecisionTreeRegressor(min_samples_split=2, min_samples_leaf = 10, random_state=0)
regression_tree.fit(X, y)
crossvalidation = KFold(n_splits=500,random_state=1, shuffle=True)
score = np.mean(cross_val_score(regression_tree,X,y, scoring='neg_mean_squared_error', cv=crossvalidation))
print('MSE %.3f'%score)