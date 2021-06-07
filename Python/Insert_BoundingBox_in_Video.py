# -*- coding: utf-8 -*-
"""
Muestra el Bounding Box del Ground Truth y el rendimiento de un tracker, superpuestos
en el video analizado

Author: Roger GOmez Nieto
Date june 28, 2020
Last modified: feb04-2021
email: rogergomez@ieee.org
"""
import cv2
import numpy as np
import scipy.io as sio  # para leer el .mat
import os  # para cambiar el directorio
from scipy.io import loadmat

number_of_trackers = 2
# se debe poner en este path
# os.chdir(r'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_blur_high')
#os.chdir(r'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0370ExFo_IndWL_LQ_C1')

os.chdir(r'C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideos')
original_video = '0092Fo_IndPW_HQ_C2'
path_gt = 'C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideosGT\\'+original_video+'_gt.txt'

# video pristine
# cap = cv2.VideoCapture('video1_blur_high.mp4')
cap = cv2.VideoCapture('3121Pri_OutPPP_C1.mp4')
fps = cap.get(cv2.CAP_PROP_FPS)

#para guardar el video
frame_width1 = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))   #se debe convertir a int para pasarlo como parameter
frame_height1 = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter('output.avi',fourcc, fps, (frame_width1,frame_height1))


# Para cargar un archivo txt
# gt = GT_Gaussian
#GT_Gaussian = data = np.loadtxt("C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideosGT/3121Pri_OutPPP_C1_gt.txt", delimiter=",", dtype="int");

gt = path_gt
# Tracker 1
tracker1_mat = sio.loadmat('0370ExFo_IndWL_LQ_C1_DLSSVM.mat')
tracker1_tracking_values = list(tracker1_mat.values())
tracker1_resuts = tracker1_tracking_values[3]
# If want to compare two trackers
if number_of_trackers > 1:
    tracker2_mat = sio.loadmat('0370ExFo_IndWL_LQ_C1_FRIQUEE560_Normalized.mat')
    tracker2_tracking_values = list(tracker2_mat.values())
    tracker2_resuts = tracker2_tracking_values[3]

gt_color = (0, 128, 0)  # green
tracker1_bb_COLOR = (255, 0, 0)  # azul
Second_Tracker_Color = (0, 0, 255)  # red
TEXT_COLOR = (255, 255, 255)  # blanco
contador = 0
while (cap.isOpened()):
    ret, frame = cap.read()
    # cv2.imshow('Frame', frame)
    # if frame is read correctly ret is True
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break
    lin1 = gt[contador, :]

    p1 = (lin1[0], lin1[1])
    p2 = (lin1[0] + lin1[2], lin1[1] + lin1[3])
    image_with_BB = cv2.rectangle(frame, p1, p2, gt_color, thickness=3)
    # esto es para colocarle el texto arriba del boundig box, para determinar cual
    # tracker se esta mostrando el resultado
    cv2.putText(
        image_with_BB,
        "GT",
        tuple(p1),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.75,
        TEXT_COLOR,
        2)
    # para convertirlo en entero
    tracker1_bb = tracker1_resuts[contador, :].astype(int)
    p3 = (tracker1_bb[0], tracker1_bb[1])
    p4 = (tracker1_bb[0] + tracker1_bb[2], tracker1_bb[1] + tracker1_bb[3])
    Second_BB = cv2.rectangle(image_with_BB, p3, p4, tracker1_bb_COLOR, thickness=3)
    cv2.putText(
        Second_BB,
        "DLSSVM",
        tuple(p3),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.75,
        TEXT_COLOR,
        2)
    # 2nd tracker
    if number_of_trackers > 1:
        tracker2_bb = tracker2_resuts[contador, :].astype(int)
        p5 = (tracker2_bb[0], tracker2_bb[1])
        p6 = (tracker2_bb[0] + tracker2_bb[2], tracker2_bb[1] + tracker2_bb[3])
        Third_BB = cv2.rectangle(Second_BB, p5, p6, Second_Tracker_Color, thickness=3)
        cv2.putText(
            Third_BB,
            "FRIQUEE",
            tuple(p6),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.75,
            TEXT_COLOR,
            2)
        out.write(Third_BB)
        cv2.imshow('tracking_results', Third_BB)
    else:
        cv2.imshow('tracking_results', Second_BB)
    contador = contador + 1
    if cv2.waitKey(10) == ord('q'):  # higher the number, slower the video show
        break
cap.release()  # release software and hardware resources
