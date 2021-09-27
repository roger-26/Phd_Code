import cv2
import time
import os
import sys
import csv

cwd = os.getcwd()
print(cwd)

def get_frames(vid_name, folder_name, ext):
    cam = cv2.VideoCapture(vid_name)

    currentframe = 0

    while (True):
        # reading from frame
        ret, frame = cam.read()

        if ret:
            # if video is still left continue creating images
            name = os.path.join(folder_name, str(currentframe + 1).rjust(4, '0') + '.' + ext)
            # print ('Creating...' + name)

            # writing the extracted images
            cv2.imwrite(name, frame)

            # increasing counter so that it will
            # show how many frames are created
            currentframe += 1
        else:
            break

    # Release all space and windows once done
    cam.release()
    cv2.destroyAllWindows()


Img_folder = 'E:\ADVSD_Video_frames'
Vid_folder = 'C:/Dropbox/Javeriana/datasets/AD-VSD/surveillanceVideosDataset/surveillanceVideos'
ext = 'jpg'

files = sorted(os.listdir(Vid_folder))

os.chdir(r'C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker')
with open('videos_MFTMayor05_30FPS_1385.csv', 'r') as csv_file:
    #archivo que contiene los nombres de los videos a extraer frames
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        current_name = row[0]
        for vid_name in files:
            #se define el nombre de la carpeta para cada video
            vid_location = os.path.join(Vid_folder, vid_name)
            basename = os.path.basename(vid_location)
            name_and_ext= os.path.splitext(basename) #para que quede el nombre sin extension
            if basename == current_name:
                print(vid_name)
                name_folder = os.path.join(Img_folder, name_and_ext[0])
                frames_location= os.path.join(name_folder, "img", )
                #se crea la carpeta si no se ha creado
                if not os.path.exists(os.path.join(Img_folder, current_name)):
                    os.makedirs(frames_location)
                get_frames(vid_location,
                           frames_location,
                           ext)
        line_count += 1
        print(line_count)
