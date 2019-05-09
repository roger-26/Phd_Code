tic 
clc;
clear all;
 close all;
 
% path_video_original='/home/javeriana/roger_gomez/Dropbox/Javeriana/Courses/DSP/Set2/Videos/041Pri_OutRK_FQ_C4_1280x720.avi';
   
path_video_original='/home/javeriana/roger_gomez/Dropbox/Javeriana/Courses/DSP/Set_Roger/005Pri_IndPO_FQ_C4.avi'

a = VideoReader(path_video_original);
FrameRate=a.FrameRate;
Number_Frames_Video_Original =a.NumberOfFrames;
[folder_video,name_video,ext_video] = fileparts(path_video_original);
path_mainFolder_Tracking = '/home/javeriana/roger_gomez/MCCT-master/TrackerMCCT/sequence/005Pri_IndPO_FQ_C4'
distance_precision_threshold=20

[results,ground_truth_original]= ...
    Call_MCCT_Tracker(path_video_original,path_mainFolder_Tracking,name_video)
 
 %%
 
 [distance_precision, average_center_location_error, overlaps] = ...
tracking_performance_measures(results.res,ground_truth_original);
average_overlap=mean(overlaps)
%Encontrando donde drafts the tracker
first_zero=find(overlaps==0,1)
failures = 0
path_video = path_video_original;
% path_video = ...
%     '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/043Exp_OutFIG_FQ_C3.mp4';
New_start=0;
New_start_GT=0;
New_start_GT = first_zero+5+New_start_GT;
calculo_ciclo = 0; % solo para controlar wl hile y no hacer toda la evaluación en la definición del
%ciclo.
%mientras queden al menos dos segundos de video y exista un failure
while (first_zero ~= 0) & (calculo_ciclo < Number_Frames_Video_Original) & (first_zero <= Number_Frames_Video_Original-FrameRate)
    disp (['el tracker tiene ', num2str(failures), ' fallas']);
    %el while da error si se usan 2 &&
    New_start = first_zero+5;
    first_zero = 0; %para que solo vuelva a entrar al ciclo while si detecta un error
    failures = failures +1;
    
    %Con esto genero el nuevo GT
    %se debe crear una nueva carpeta para cada ejecución
    New_Folder_Tracking = strcat(path_mainFolder_Tracking,'/failure',num2str(failures));
    name_New_Video = strcat('failure',num2str(failures)');
    
    mkdir(New_Folder_Tracking)
    New_BB = ground_truth_original(New_start_GT:end,:);
    New_GT    = ...
        strcat(New_Folder_Tracking,'/groundtruth_rect.txt');
    fileID = fopen(New_GT,'w');
    dlmwrite(New_GT,New_BB,'delimiter',',');
    
    %Generando el nuevo video, se debe leer el video cada vez que se entra
    a = VideoReader(path_video);
    path_video=strcat(New_Folder_Tracking,'/',name_New_Video,'.avi');
    Number_Frames_Video =a.NumberOfFrames;
    
    writerObj1 = VideoWriter(path_video,'Uncompressed AVI');
    writerObj1.FrameRate=FrameRate;
    open(writerObj1);
    for img = New_start:Number_Frames_Video
        im=read(a,img);
        writeVideo(writerObj1,im);
        if mod(img,10)==0
            img
        end
    end
    close(writerObj1)
    
    %Ejecutando de nuevo el tracker
%     delimiter = ',';
%     ground_truth_new = importdata(New_GT,delimiter);
%     path_mainFolder_Tracking_new = strcat(path_mainFolder_Tracking, '_', strcat(failures));
%     [tracking_results_new]=...
%         tracker_dsst(ground_truth_new(1,:),path_video,path_mainFolder_Tracking_new);
    
    [results, ground_truth_new] = ...
        Call_MCCT_Tracker(path_video,path_mainFolder_Tracking,name_New_Video);
    
    %calculando si volvio a fallar
    [distance_precision, average_center_location_error, overlaps] = ...
    tracking_performance_measures(results.res, ground_truth_new,distance_precision_threshold);
    %Encontrando donde drafts the tracker
    first_zero=find(overlaps==0,1)
    %Habia un error porque no se le estaba restando un 1
    New_start_GT = first_zero+5+New_start_GT-1; %para que sume los anteriores frames al GT y no coja
    %solo los iniciales sin el offset
    Numero_Seg_noCalculan_AlFinal = 2;
    calculo_ciclo = ceil(New_start + (Numero_Seg_noCalculan_AlFinal*FrameRate));
end
failures
S=30
Tracker_Robustness = exp(-S*(failures/Number_Frames_Video_Original))
average_overlap
close all
plot(Tracker_Robustness, average_overlap,'*')
axis([0 1 0 1])
grid minor
legend('tracker MCCT')
toc