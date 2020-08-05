close all;

video_number ='1';%El 2 es raul posada
% filename =    'C:\DeepVision\PARQUEADEROS\FACHADA RAUL POSADA DE 11.30 AM A 02.30 PM.avi'
% filename =    'D:\DeepVision\PARQUEADEROS\FACHADA RAUL POSADA DE 04.30 PM A 07.30 PM.avi'
% filename =    'D:\DeepVision\PARQUEADEROS\FACHADA RAUL POSADA DE 07.30 PM A 10.00 PM.avi'

% filename='C:\DeepVision\PARQUEADEROS\19 DE SEPTIEMBRE DEL 2019 PARQUEADERO R1 FILA 11 Y 12 DE  11.30 AM A 02.30 PM.avi'
% filename='C:\DeepVision\PARQUEADEROS\19 DE SEPTIEMBRE DEL 2019 PARQUEADERO R1 FILA 11 Y 12 DE 04.30 PM A 07.30 PM.avi'
filename='C:\DeepVision\PARQUEADEROS\19 DE SEPTIEMBRE DEL 2019 PARQUEADERO R1 FILA 11 Y 12 DE 07.30 PM A 10.00 PM.avi'

time_day_video= '_t3';


video  = VideoReader(filename);
% vidMat = read(video);

current_slot = 12;
%%
clc
fs     = get(video, 'FrameRate');
duration_video = get(video, 'Duration');
frame = read(video, 50);
fig=imshow(frame)
[xi, yi] = getpts %solo marcar dos puntos: uno en la esquina superior izquierda, otro en la inferior derecha
bb_video = [xi, yi];
%guardando el Bounding Box del video
name_bb_slot = strcat...
    ('C:\DeepVision\Extracted_Images_Parking_PUJC_Slots\BoundingBox_Slots\','slot',num2str(current_slot),'_video',num2str(video_number),'.mat');
save(name_bb_slot,'bb_video')
fps = video.FrameRate;

% xi=[bb_video(1,1),bb_video(2,1)]
% yi = [bb_video(1,2),bb_video(2,2)]
%% guardando la imagen
% folder_to_save = 'C:\DeepVision\Extracted_Images_Parking_PUJC_Slots\busy\';
folder_to_save = 'C:\DeepVision\Extracted_Images_Parking_PUJC_Slots\free\';

warning('off','all');
tic



% class='_b';gpp
class='_f';
parfor i = 1:53340
% for i = 2590:24780
    i
    vidMat=read(video, i);
    cutted_image = (vidMat(yi(1):yi(2),xi(1):xi(2),:));
    serial_number = i;
    name_file = ...
        strcat('v',video_number,time_day_video, class,'_s',num2str(current_slot),'_',num2str(serial_number));
    imwrite(cutted_image,strcat(folder_to_save,name_file,'.png'));
end
toc