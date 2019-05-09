%ESTE Código llama a la función que detecta cuando se agrega un archivo
%nuevo en una carpeta, la ruta que se le pasa es del directorio donde esta
%la carpeta en la que se va a agregar el video nuevo, la segunda ruta no
%importa tanto porque dentro de la función detectfile se llama la función
%que llama el tracker dsst


%comment this line in the first execution  
%stop(timerObj)


  clear all
  clc
%se le pasa la carpeta donde esta alojada la carpeta new_video, la otra
%funcion no es tan importante porque igual el tracker lo llamo desde la
%funcion detectfile
timerObj = ...
detectFile('/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD', '/home/javeriana/roger_gomez/DSST2/DSST2/call_tracker.m')
% timerObj=detectFile('/home/javeriana/new_videos_input', '/home/javeriana/roger_gomez/DSST2/DSST2/call_tracker.m')
 