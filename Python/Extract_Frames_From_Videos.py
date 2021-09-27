# Este codigo extrae los frames de los videos que esten en una carpeta, y los guarda en otra carpeta en una subfolder img
# para cumplir con el formato OTB


import cv2
import time
import os
import sys
cwd = os.getcwd()
print (cwd)
def get_frames(vid_name, folder_name, ext):
    cam = cv2.VideoCapture(vid_name) 

    currentframe = 0
    number_zeros_in_name= 8 #el numero de digitos que tendra el nombre
    while(True): 
        # reading from frame 
        ret,frame = cam.read() 

        if ret: 
            # if video is still left continue creating images 
            name = os.path.join(folder_name,str(currentframe+1).rjust(number_zeros_in_name,'0') + '.' + ext)
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
	
# Img_folder = '/home/vigilcali/roger_nieto/deblurred_videos/Videos_Set3_1K_Images'
Img_folder = 'C:/Users/roger/Desktop/Videos_seleccionados/frames'

Vid_folder = 'C:/Users/roger/Desktop/Videos_seleccionados'
# Vid_folder = '/home/vigilcali/roger_nieto/deblurred_videos/Videos_Set3_1K'
ext = 'jpg'

files = sorted(os.listdir(Vid_folder))
#para extraer todos los videos que esten en el folder
# Creates the folder to save the images
for f in files:
    if not os.path.exists(os.path.join(Img_folder, f[0:f.find('.')])):
        os.makedirs(os.path.join(Img_folder, f[0:f.find('.')]))
        new_folder_temp = Img_folder+ '/'+f[0:f.find('.')]
        os.makedirs(os.path.join(new_folder_temp, 'img'))


for vid_name in files:
    vid_location = os.path.join(Vid_folder,vid_name)
    frames_location2 = os.path.join(Img_folder,vid_name[0:vid_name.find('.')])
    frames_location= frames_location2 + '/img/'
    get_frames(vid_location,
               frames_location,
               ext)