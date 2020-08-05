# -*- coding: utf-8 -*-
"""
Created on Sat Aug  1 14:44:44 2020

@author: Roger Gomez Nieto
"""
import imageio
import cv2
import tkinter as tk
from tkinter import *
from PIL import ImageTk, Image
from pathlib import Path
import os 

os.chdir(r'C:\Users\PUJC\Documents')



video = imageio.get_reader('1_27_08_19.mp4')

#entre más alto el número, menor es la velocidad del video
delay = int(10000 / video.get_meta_data()['fps'])
     
def stream(label):
 
  try:
    image = video.get_next_data()
  except:
    video.close()
    return
  label.after(delay, lambda: stream(label))
  frame_image = ImageTk.PhotoImage(Image.fromarray(image))
  label.config(image=frame_image)
  label.image = frame_image
  
def getorigin(eventorigin):
    global x0,y0
    x0 = eventorigin.x
    y0 = eventorigin.y
    print(x0,y0)
    w.bind("<Button 1>",getextentx)
#mouseclick event

  
if __name__ == '__main__':
  root = tk.Tk()
  w = Canvas(root, width=500, height=100)
  w.pack()#meterlo dentro de la ventana grande
  my_label = Label(root)
  my_label.pack()
  my_label.after(delay, lambda: stream(my_label))
  root.geometry("1280x720")
  w.bind("<Button 1>",getorigin)
  root.mainloop()






#mouseclick event





# win = tk.Tk() #los parentesis indican que es una instancia
# win.title("Deepvision - Parking lot")


# #win.resizable(False,False)
# ttk.Label(win,text="A Label").grid(column=0,row=0)

# win.mainloop()

