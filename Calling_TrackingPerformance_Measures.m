clc;
close all
clear all

%Aqui el tracker se ejecuta por primera vez

BB=[668 332 124 339]
path_mainFolder_Tracking= '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/results'
path_video = '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/043Exp_OutFIG_FQ_C3.mp4'
tracker_dsst(BB,path_video,path_mainFolder_Tracking)

failures=0
path_positions=...
  '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/results/043Exp_OutFIG_FQ_C3_results.txt';
delimiterIn = ',';
positions = importdata(path_positions,delimiterIn);

ground_truth_path=...
    '/home/javeriana/roger_gomez/Dropbox/Javeriana/Courses/DSP/Video_with_Annotations/DSVD_gt.txt'; 
ground_truth = importdata(ground_truth_path,delimiterIn);
distance_precision_threshold = 20;
%distance_precision es el porcentaje de frames donde la distance entre BB
%es menor al precision_threshold
[distance_precision, average_center_location_error, overlaps] = ...
    tracking_performance_measures(positions, ground_truth, distance_precision_threshold);
%Encontrando donde drafts the tracker
first_zero=find(overlaps==0,1)
if first_zero~=0
    failures=failures+1
    %add 5 frames to restart the tracker
    New_start = first_zero+5
end

%generando un nuevo video empezando desde donde se debe reiniciar el
%tracker
absolute_path=...
'/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/043Exp_OutFIG_FQ_C3.mp4';
[folder_video,name_video,ext_video] = fileparts(absolute_path)
name_video_recorted=strcat(folder_video,'/', name_video,'_Fail', num2str(failures),'.avi');

vid1 = VideoReader(absolute_path);
writerObj1 = VideoWriter(name_video_recorted, 'Uncompressed AVI');
writerObj1.FrameRate=vid1.FrameRate;
open(writerObj1);
Number_Of_Frames_Video_Original =vid1.NumberOfFrames
for i = New_start : Number_Of_Frames_Video_Original
    im=read(vid1,i);
% %                 f = @() rectangle('position',[x y w h]);
%     f = @() rectangle('position',gt_Initial(i,:));
%     params = {'linewidth',1,'edgecolor','g'};
%     imgOut = insertInImage(im,f,params);
    writeVideo(writerObj1,im);
    i
end
close(writerObj1)

%llamando a la función del tracker
new_BB= ground_truth(New_start,:)
path_mainFolder_Tracking=...
 '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/results/'
path_save_results=strcat(path_mainFolder_Tracking,name_video,'_Fail', num2str(failures));
mkdir(path_save_results);
tracker_dsst(new_BB,name_video_recorted,path_save_results)
