# Roger Gomez Nieto - December 02, 2021

import numpy as np

from sklearn.datasets import load_iris
iris = load_iris()
X,y = iris.data, iris.target
features = iris.feature_names

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn import tree

crossvalidation = KFold(n_splits=5,random_state=1, shuffle=True)

for depth in range(1, 10):
    #create the tree decision, using sklearn
    #con maximum 10 leafs, the accuracy is lower, but the tree is more simple
    tree_classifier = tree.DecisionTreeClassifier(max_depth=depth, random_state=0, min_samples_leaf=10)
    if tree_classifier.fit(X, y).tree_.max_depth < depth:
        break
    score = np.mean(cross_val_score(tree_classifier, X, y, scoring='accuracy', cv=crossvalidation))
    #para imprimir solo con 3 decimales.
    print('Depth: %i  Accuracy : %.3f'% (depth,score))