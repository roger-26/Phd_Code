# -*- coding: utf-8 -*-
"""
Created on Mon Dec  9 15:18:47 2019

@author: javeriana
"""

import numpy as np
import scipy.io
import cv2
import sys
#ii you want to convert to avi format
#import os
#os.system("ffmpeg -i video1.mp4 -vcodec copy -acodec copy video1.avi")

cap = cv2.VideoCapture(sys.argv[1])

name_video = sys.argv[1]
list_frames=[]

while(cap.isOpened()):
    ret, frame = cap.read()
    if ret == True:

       list_frames.append(frame)

       #cv2.imshow("windows",frame)
       #if cv2.waitKey(25) & 0xFF == ord('q'):
          #break
    else:
      break


cap.release()

scipy.io.savemat('video.mat', dict(list_frames=list_frames))
