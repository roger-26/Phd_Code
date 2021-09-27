import numpy as np
import cv2
import matplotlib.pyplot as plt
from glob import glob
import os

os.chdir(r'F:\datasets\VOT2020-ST\zebrafish1')

with open('groundtruth.txt', 'r') as f:
    lines = f.readlines()
lines = [l.split(',')[:4] for l in lines]

#para eliminar la m al inicio

for i, l in enumerate(lines):
    lines[i][0] = l[0][1:]
lines = [list(map(int, l)) for l in lines]

#Se buscan si hay componentes en 0 y se hace una interpolación
for i in range(len(lines)):
    if lines[i][1] == 0:
        print(i)
        print(lines[i])
        lines[i][0:]=np.add(lines[i-1][0:],lines[i+1][0:])/2
        aux=np.add(lines[i-1][0:],lines[i+1][0:])
        aux=aux/2

#Para que guarde la lista en un txt sin corchetes.
with open('groundtruth2.txt', 'a') as f:
    for item in lines:
        res = str(item)[1:-1]
        print(res)
        f.write("%s\n" % res)
    f.close()
