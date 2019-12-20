function [video_4d] = read_video_ubuntu (path_video,name_mat_to_save)
%path_video es la ruta absoluta
%lo unico que se debe hacer es cambiar la ruta a donde se guarde el archivo
%python aqui en cd, se debe disponer de al menos 5 gb en la carpeta. cada
%video nuevo reemplaza al anterior. 
%result= read_video_ubuntu(...
%'/media/javeriana/HDD_4TB/AppDrivenTracker/videos70_025resolution/video1.mp4','video2.mat');

cd '/media/javeriana/VISION_2/roger_gomez/python_scripts/'
string_to_execute = ...
    strcat(['python read_video.py ' path_video ' ' name_mat_to_save]);
system(string_to_execute);
aux =load(name_mat_to_save);
video_4d = aux.arr;
end