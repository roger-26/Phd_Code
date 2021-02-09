# -*- coding: utf-8 -*-
"""
Muestra el Bounding Box del Ground Truth y el rendimiento de un tracker, superpuestos
en el video analizado. También guarda el video de resultado, en la misma carpeta que se pase en os.chdir,
con el nombre "output.avi"

Author: Roger GOmez Nieto
Date creation: feb04-2021
Last modified: feb04-2021
email: rogergomez@ieee.org
"""
import cv2
import numpy as np
import scipy.io as sio          # para leer el .mat
import os                       # para cambiar el directorio
from scipy.io import loadmat
import glob

#folder donde se va a guardar el video
os.chdir(r'C:\surveillanceVideos_Frames\0001Pri_IndWL_MQ_C4\img\I2')
fps = 30

img_array = []
for filename in glob.glob('C:/surveillanceVideos_Frames/0001Pri_IndWL_MQ_C4/img/I2/*.png'):
    img = cv2.imread(filename)
    height, width, layers = img.shape
    size = (width, height)
    img_array.append(img)

out = cv2.VideoWriter('project.avi', cv2.VideoWriter_fourcc(*'DIVX'), fps, size)

for i in range(len(img_array)):
    out.write(img_array[i])
out.release()
