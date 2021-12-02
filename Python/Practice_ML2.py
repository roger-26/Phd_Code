import sys
import pip
import scipy
import numpy
import sklearn

import matplotlib
import pandas as pd

#importing the needed libraries
from sklearn.metrics import accuracy_score
from sklearn.metrics import classification_report
from sklearn.model_selection import  cross_val_score
from sklearn.metrics import confusion_matrix
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.linear_model import LogisticRegression
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.svm import SVC
from sklearn.model_selection import StratifiedKFold
from sklearn.model_selection import train_test_split

from matplotlib import pyplot as plt
from pandas.plotting import scatter_matrix
from pandas import read_csv

#importing the dataset
dataset_iris = pd.read_csv(r'G:\Downloads\iris.csv')
dataset_iris.head()
df = pd.DataFrame(dataset_iris,columns=['sepal_length','sepal_width','petal_length','petal_width','species'])
print(df.head())
print(df.shape)
#count es para contar el número de ocurrencias o filas por cada columna
print("the number of rows=", df.count())
#agrupando
print("\n", df.groupby('species').size())

#creating a new table with other data

sales_data = {'item':['butter', 'cream','eggs','milk','chocolate'],
              'sales':[20000,15000,35000,40000,45000],
              'year':[2010,2011,2012,2013,2014],
              'rank':[2,3,1,1,2]}

df2=pd.DataFrame(sales_data)
print(df2)

