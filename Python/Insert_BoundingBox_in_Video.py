# -*- coding: utf-8 -*-
"""
Muestra el Bounding Box del Ground Truth y el rendimiento de un tracker, superpuestos
en el video analizado

Author: Roger GOmez Nieto  
Date june 28, 2020
email: rogergomez@ieee.org
"""
import cv2
import numpy as np
import scipy.io as sio
import os

number_of_trackers = 1
#se debe poner en este path
os.chdir(r'c:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_pristine')


#video pristine
# DLSSVM_Tracking_mat = sio.loadmat('DLSSVM_tracking_video1_Pristine.mat')
cap = cv2.VideoCapture('video1.mp4')




gt_mat = sio.loadmat('groundtruth_rect.mat')
gt_values = list(gt_mat.values())
gt=gt_values[3]#esta posición hay que verificarla porque puede cambiar

tracker1_mat = sio.loadmat('DLSSVM_tracking_video1_Pristine.mat')
tracker1_tracking_values = list(tracker1_mat.values())
tracker1_resuts = tracker1_tracking_values[3]

if number_of_trackers >1:
    tracker2_mat = sio.loadmat('FRIQUEE_tracking_video1_Pristine.mat')
    tracker2_tracking_values = list(tracker2_mat.values())
    tracker2_resuts = tracker2_tracking_values[3]




    
gt_color = (0, 128, 0)   #green
tracker1_bb_COLOR = (255, 0, 0)  #azul
Second_Tracker_Color = (0,0,255)#red
TEXT_COLOR = (255, 255, 255)  #blanco
contador = 0
while (cap.isOpened()):
    ret, frame = cap.read()
    # cv2.imshow('Frame', frame) 
    # if frame is read correctly ret is True
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break
    lin1=gt[contador,:]
  
    p1=(lin1[0],lin1[1])
    p2=(lin1[0]+lin1[2],lin1[1]+lin1[3])
    image_with_BB = cv2.rectangle(frame, p1, p2, gt_color, thickness=3)
    #esto es para colocarle el texto arriba del boundig box, para determinar cual
    #tracker se esta mostrando el resultado
    cv2.putText(
        image_with_BB,
        "GT",
        tuple(p1),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.75,
        TEXT_COLOR,
        2)
      #para convertirlo en entero
    tracker1_bb = tracker1_resuts[contador,:].astype(int)
    p3=(tracker1_bb[0],tracker1_bb[1])
    p4=(tracker1_bb[0]+tracker1_bb[2],tracker1_bb[1]+tracker1_bb[3])
    Second_BB = cv2.rectangle(image_with_BB, p3, p4, tracker1_bb_COLOR, thickness=3)
    cv2.putText(
        Second_BB,
        "DLSSVM",
        tuple(p3),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.75,
        TEXT_COLOR,
        2)
    #2nd tracker
    if number_of_trackers >1:
        tracker2_bb = tracker2_resuts[contador,:].astype(int)
        p5=(tracker2_bb[0],tracker2_bb[1])
        p6=(tracker2_bb[0]+tracker2_bb[2],tracker2_bb[1]+tracker2_bb[3])
        Third_BB = cv2.rectangle(Second_BB, p5, p6, Second_Tracker_Color, thickness=3)
        cv2.putText(
            Third_BB,
            "FRIQUEE",
            tuple(p6),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.75,
            TEXT_COLOR,
            2)
        cv2.imshow('tracking_results', Third_BB)
    else:
        cv2.imshow('tracking_results', Second_BB)
    contador = contador +1
    if cv2.waitKey(200) == ord('q'):#higher the number, slower the video show
        break
cap.release() #release software and hardware resources
