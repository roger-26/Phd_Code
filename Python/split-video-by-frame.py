'''
Using OpenCV takes a mp4 video and produces a number of images.
Note: if u do not have open cv installed you must have to install it with the following commands

First do run these commands inside Terminal/CMD:

    conda update anaconda-navigator  
    conda update navigator-updater  

then the issue for the instruction below will be resolved
for windows if you have anaconda installed, you can simply do

    pip install opencv-python
or

    conda install -c https://conda.binstar.org/menpo opencv

if you are on linux you can do :

    pip install opencv-python
or

    conda install opencv

'''
import cv2
#import numpy as np
import os

# Playing video from file:

for path_video in range (7, 24):            
        
    cap = cv2.VideoCapture('D:/Javeriana_OTV/AppDrivenTracker/videos70/video' + str(path_video) + '.mp4')
    
    
    newpath = r'D:/Javeriana_OTV/AppDrivenTracker/videos70/video' + str(path_video) 
    try:
        if not os.path.exists(newpath):
            os.makedirs(newpath)
    except OSError:
        print ('Error: Creating directory of data')
    
    l = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        
    for currentFrame in range(1, l+1):
        
        if currentFrame < 10:
            path_vid = '000' + str(currentFrame)
        elif currentFrame < 100 and currentFrame >= 10:
            path_vid = '00' + str(currentFrame)
        else:
            path_vid = '0' + str(currentFrame)
        # Capture frame-by-frame
        ret, frame = cap.read()
    
        # Saves image of the current frame in jpg file
        name = 'D:/Javeriana_OTV/AppDrivenTracker/videos70/video' + str(path_video) + '/' + path_vid + '.png'
        print ('Creating...' + name)
        cv2.imwrite(name, frame)
    
    
    # When everything done, release the capture
    cap.release()
    cv2.destroyAllWindows()