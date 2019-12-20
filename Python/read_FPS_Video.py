import numpy as np
import scipy.io
import cv2
import sys
import os


cap = cv2.VideoCapture(sys.argv[1])

# cap = cv2.VideoCapture("/home/rogergo/Videos/video_demo_short.mp4")
# cap = cv2.VideoCapture("/home/rogergo/AppDrivenTracker/videos70/video1.mp4")

num_frames   = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
fps = cap.get(cv2.CAP_PROP_FPS)

print("FPS= {}".format(fps))
write_FPS = open(sys.argv[2],"w")

# write_FPS = open("/home/rogergo/Videos/FPS.txt","w")
write_FPS.write(str(fps))
write_FPS.close()   