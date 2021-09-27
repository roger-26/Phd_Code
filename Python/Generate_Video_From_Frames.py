#Este código convierte los frames de un video en formato .avi
#Roger GOmez 23 sep 2021



import cv2
import numpy as np
import glob
import os

# consiguiendo los nombres de los carpetas
#print [name for name in os.listdir("F:\datasets\VOT2020-ST/") if os.path.isdir(name)]
import os

folder = 'F:\datasets\VOT2020-ST_1-4_Scale/'

sub_folders = [name for name in os.listdir(folder) if os.path.isdir(os.path.join(folder, name))]

#print(sub_folders[1])

#este for es para que procese todos los videos de la carpeta
for ii in range(1,59):

    img_array = []
    name_total = 'F:\datasets\VOT2020-ST_1-4_Scale/' + sub_folders[ii] + '\img/*.jpg'
    for filename in glob.glob(name_total):
        img = cv2.imread(filename)
        height, width, layers = img.shape
        size = (width, height)
        img_array.append(img)

    fps=30

    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    name_save_video = 'F:\datasets\VOT2020-ST_1-4_Scale/videos_AVI/'+sub_folders[ii]+'.avi'
    out = cv2.VideoWriter(name_save_video,fourcc, fps, (width,height))

    #out = cv2.VideoWriter('C:\Users/roger\Desktop/project.avi', cv2.VideoWriter_fourcc(*'DIVX'), 15, size)

    for i in range(len(img_array)):
        out.write(img_array[i])
    out.release()