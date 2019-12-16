# -*- coding: utf-8 -*-
"""
Created on Fri Dec  6 17:12:34 2019

@author: javeriana
"""


import cv2
import numpy as np
import scipy.io
import sys 

#capture = cv2.VideoCapture('/media/javeriana/HDD_4TB/AppDrivenTracker/videos70_025resolution/video1.mp4')

capture = cv2.VideoCapture(sys.argv[1])
read_flag, frame = capture.read()
vid_frames = []
i = 1
    # print read_flag

dimension=(480,270)
while (read_flag):
    print i
    frame_scaled = cv2.resize(frame, dimension)
    vid_frames.append(frame_scaled)
            #                print frame.shape
    read_flag, frame = capture.read()
    i += 1
vid_frames = np.asarray(vid_frames, dtype='uint8')[:-1]
    # print 'vid shape'
    # print vid_frames.shape
capture.release()
print("saving video to disk")

scipy.io.savemat(sys.argv[2], mdict={'arr': vid_frames}, do_compression=True)
#scipy.io.savemat('arrdata.mat', mdict={'arr': vid_frames})