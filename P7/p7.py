#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on 7/11/2017

@author: leonvillapun
"""

#Data preprocessing template

#Importing the libraries

import numpy as np #Libreria de matematicas
import matplotlib.pyplot as plt #Libreria de graficas
import pandas as pd #Libreria para importar set de datos y administrarlos
import math
 


#Methods

def mean(data):
    suma = 0
    for i in range(0,len(data)):
        suma = suma + data[i]
    return float(suma / len(data))

 
def std(data):
    media = mean(data)
    suma = 0
    for i in range(0, len(data)):
        suma = suma + pow((data[i] - media), 2)
    return math.sqrt(suma/(len(data)-1))

def meanByClass(data, res, name):
    classList = []
    for i in range(0, len(data)):
        if res[i] == name:
            classList.append(data[i])
    
    return mean(classList)

def stdByClass(data, res, name):
    classList = []
    for i in range(0,len(data)):
        if res[i] == name:
            classList.append(data[i])
    
    return std(classList)


def calculateProbability(x, mean, stdev):
	exponent = math.exp(-(math.pow(x-mean,2)/(2*math.pow(stdev,2))))
	return (1 / (math.sqrt(2*math.pi) * stdev)) * exponent


def probabilityOfClass(data, mean, std):
    prob = calculateProbability(data[0], mean[0], std[0]) * calculateProbability(data[1], mean[1], std[1]) * calculateProbability(data[2], mean[2], std[2]) * calculateProbability(data[3], mean[3], std[3])
    return prob

def maxProb(t1,t2,t3):
    return max(t1,t2,t3)


#Import data sets
 
t_dataset = pd.read_csv('iris.csv')
test = pd.read_csv('besdekiris.csv')

def predict():

    
    return


#Arreglos de datos desde el dataset
    
t_dataset_matrix = t_dataset.iloc[:, :-1].values
    
  
sepal_length = t_dataset.iloc[:,0].values
sepal_width = t_dataset.iloc[:,1].values
petal_length = t_dataset.iloc[:,2].values
petal_width = t_dataset.iloc[:,3].values
    
    
results = t_dataset.iloc[:,4].values


sepal_length_t1 = []
sepal_length_t2 = []
sepal_length_t3 = []
sepal_width_t1 = []
sepal_width_t2 = []
sepal_width_t3 = []
petal_length_t1 = []
petal_length_t2 = []
petal_length_t3 = []
petal_width_t1 = []
petal_width_t2 = []
petal_width_t3 = []





#Graficar
print("Sepal length vs sepal width")
plt.plot(sepal_length, sepal_width, 'ro')
plt.show()
print("Petal length vs petal width")
plt.plot(petal_length, petal_width, 'ro')
plt.show()
print("Sepal length vs petal length")
plt.plot(sepal_length, petal_length, 'ro')
plt.show()
print("Sepal length vs petal width")
plt.plot(sepal_length, petal_width, 'ro')
plt.show()
print("Sepal width vs Petal length")
plt.plot(sepal_width, petal_length, 'ro')
plt.show()
print("Sepal width vs petal width")
plt.plot(sepal_width, petal_width, 'ro')
plt.show()
    
#Medidas de tendencia central
    
SL_mean_C1 = meanByClass(sepal_length, results, "Iris-setosa")
SL_mean_C2 = meanByClass(sepal_length, results, "Iris-versicolor")
SL_mean_C3 = meanByClass(sepal_length, results, "Iris-virginica")
SL_std_C1 = stdByClass(sepal_length, results, "Iris-setosa")
SL_std_C2 = stdByClass(sepal_length, results, "Iris-versicolor")
SL_std_C3 = stdByClass(sepal_length, results, "Iris-virginica")

SW_mean_C1 = meanByClass(sepal_width, results, "Iris-setosa")
SW_mean_C2 = meanByClass(sepal_width, results, "Iris-versicolor")
SW_mean_C3 = meanByClass(sepal_width, results, "Iris-virginica")
SW_std_C1 = stdByClass(sepal_width, results, "Iris-setosa")
SW_std_C2 = stdByClass(sepal_width, results, "Iris-versicolor")
SW_std_C3 = stdByClass(sepal_width, results, "Iris-virginica")
    
PL_mean_C1 = meanByClass(petal_length, results, "Iris-setosa")
PL_mean_C2 = meanByClass(petal_length, results, "Iris-versicolor")
PL_mean_C3 = meanByClass(petal_length, results, "Iris-virginica")
PL_std_C1 = stdByClass(petal_length, results, "Iris-setosa")
PL_std_C2 = stdByClass(petal_length, results, "Iris-versicolor")
PL_std_C3 = stdByClass(petal_length, results, "Iris-virginica")

PW_mean_C1 = meanByClass(petal_width, results, "Iris-setosa")
PW_mean_C2 = meanByClass(petal_width, results, "Iris-versicolor")
PW_mean_C3 = meanByClass(petal_width, results, "Iris-virginica")
PW_std_C1 = stdByClass(petal_width, results, "Iris-setosa")
PW_std_C2 = stdByClass(petal_width, results, "Iris-versicolor")
PW_std_C3 = stdByClass(petal_width, results, "Iris-virginica")
    
    
m1 = [SL_mean_C1, SW_mean_C1, PL_mean_C1, PW_mean_C1]
std1 = [SL_std_C1, SW_std_C1, PL_std_C1, PW_std_C1]
    
m2 = [SL_mean_C2, SW_mean_C2, PL_mean_C2, PW_mean_C2]
std2 = [SL_std_C2, SW_std_C2, PL_std_C2, PW_std_C2]

m3 = [SL_mean_C3, SW_mean_C3, PL_mean_C3, PW_mean_C3]
std3 = [SL_std_C3, SW_std_C3, PL_std_C3, PW_std_C3]

prob1 = probabilityOfClass([5.9, 3.0, 5.1, 1.8], m1, std1)
prob2 = probabilityOfClass([5.9, 3.0, 5.1, 1.8], m2, std2)
prob3 = probabilityOfClass([5.9, 3.0, 5.1, 1.8], m3, std3)
    
election = maxProb(prob1,prob2,prob3)
    
print(election)


#evaluar cada valor del test set

results = []
true_results = test.iloc[:, 4].values

for i in range(0, len(test)):
    actualLine = test.iloc[i, :-1].values
    prob1 = probabilityOfClass(actualLine, m1, std1)
    prob2 = probabilityOfClass(actualLine, m2, std2)
    prob3 = probabilityOfClass(actualLine, m3, std3)
    
    election = maxProb(prob1,prob2,prob3)
    result = ""
    if(election is prob1):
        result = "Iris Setosa"
        results.append("Iris-setosa")
    if(election is prob2):
        result = "Iris Versicolor"
        results.append("Iris-versicolor")
    if(election is prob3):
        result = "Iris Virginica"
        results.append("Iris-virginica")
    
    print(i, result, true_results[i])
    

w, h = 3, 3;
Matrix = [[0 for x in range(w)] for y in range(h)] 

#matriz de confusion
for i in range(0,len(results)):
    #print(results[i], true_results[i])
    if(results[i] == "Iris-setosa"):
        if(true_results[i] == "Iris-setosa"):
            Matrix[0][0] = Matrix[0][0] + 1
        if(true_results[i] == "Iris-versicolor"):
            Matrix[0][1] = Matrix[0][1] + 1
        if(true_results[i] == "Iris-virginica"):
            Matrix[0][2] = Matrix[0][2] + 1
    if(results[i] == "Iris-versicolor"):
        if(true_results[i] == "Iris-setosa"):
            Matrix[1][0] = Matrix[0][0] + 1
        if(true_results[i] == "Iris-versicolor"):
            Matrix[1][1] = Matrix[1][1] + 1
        if(true_results[i] == "Iris-virginica"):
            Matrix[1][2] = Matrix[1][2] + 1
    if(results[i] == "Iris-virginica"):
        if(true_results[i] == "Iris-setosa"):
            Matrix[2][0] = Matrix[0][0] + 1
        if(true_results[i] == "Iris-versicolor"):
            Matrix[2][1] = Matrix[2][1] + 1
        if(true_results[i] == "Iris-virginica"):
            Matrix[2][2] = Matrix[2][2] + 1
    
            
for i in range(0,len(Matrix)):
    print (Matrix[i][0],Matrix[i][1],Matrix[i][2])

accuracy = ((Matrix[0][0] + Matrix[1][1] + Matrix[2][2]) / len(results)) * 100

print(accuracy)






    