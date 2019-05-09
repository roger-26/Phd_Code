tic
clc;
close all
clear all

%Aqui el tracker se ejecuta por primera vez
%Aqui se coloca el bounding box inicial para el primer frame
BB=[1736,188,103,252];
%carpeta donde se van a guardar los resultados e imagenes de los videos,
%las carpetas que se crean para los fallos no son hijas sino hermanas de
%esta
path_mainFolder_Tracking= ...
    '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/005Pri_IndPO_FQ_C4';
path_video_original = ...
    '/home/javeriana/roger_gomez/Dropbox/Javeriana/Courses/DSP/Set_Roger/005Pri_IndPO_FQ_C4.avi';
a = VideoReader(path_video_original);
FrameRate=a.FrameRate;
Number_Frames_Video_Original =a.NumberOfFrames;
[folder_video,name_video,ext_video] = fileparts(path_video_original);
ground_truth_path=...
    '/home/javeriana/roger_gomez/Dropbox/Javeriana/Courses/DSP/Set_Roger/005Pri_IndPO_FQ_C4.txt';
delimiter = ',';
ground_truth_original = importdata(ground_truth_path,delimiter);
[tracking_results]=...
    tracker_dsst(BB,path_video_original,path_mainFolder_Tracking);
%%
distance_precision_threshold = 20;
%distance_precision es el porcentaje de frames donde la distance entre BB
%es menor al precision_threshold
%se debe pasar el GT como matriz
[distance_precision, average_center_location_error, overlaps] = ...
    tracking_performance_measures(tracking_results, ground_truth_original, distance_precision_threshold);
average_overlap = mean (overlaps)
%Encontrando donde drafts the tracker
first_zero=find(overlaps==0,1)
failures = 0
path_video = path_video_original;
%     '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/043Exp_OutFIG_FQ_C3.mp4';
New_start=0;
New_start_GT=0;
New_start_GT = first_zero+5+New_start_GT;
calculo_ciclo = 0; % solo para controlar wl hile y no hacer toda la evaluación en la definición del
%ciclo.
%mientras queden al menos dos segundos de video y exista un failure
while (first_zero ~= 0) & (calculo_ciclo < Number_Frames_Video_Original)
    disp (['el tracker tiene ', num2str(failures), ' fallas']);
    %el while da error si se usan 2 &&
    New_start = first_zero+5; %un espacio en frames que se le da para que no quede pegado en el mismo error
    first_zero = 0  %para que solo vuelva a entrar al ciclo while si detecta un error
    failures = failures +1
    
    %Con esto genero el nuevo GT
    New_BB = ground_truth_original(New_start_GT:end,:);
    New_GT    = ...
        strcat(path_mainFolder_Tracking,'/',name_video,'_failure',num2str(failures),'GT.txt');
    fileID = fopen(New_GT,'w');
    dlmwrite(New_GT,New_BB,'delimiter',',');
    
    %Generando el nuevo video, se debe leer el video cada vez que se entra
    a = VideoReader(path_video);
    Number_Frames_Video =a.NumberOfFrames;
    path_video=strcat(path_mainFolder_Tracking,'/',name_video,'_failure',num2str(failures),'.avi');
    writerObj1 = VideoWriter(path_video,'Uncompressed AVI');
    writerObj1.FrameRate=FrameRate;
    open(writerObj1);
    %esta comprobación se hace porque a veces el tamaño varia por causas
    %aun no conocidas, entonces para verificar que el número de frames
    %coincida con el tamaño del GT
    if (Number_Frames_Video-New_start)>(Number_Frames_Video_Original-New_start_GT)
        New_start = New_start +1
    end
    for img = New_start:Number_Frames_Video
        im=read(a,img);
        writeVideo(writerObj1,im);
        if mod(img,10)==0
            img
        end
    end
    close(writerObj1)
    %Ejecutando de nuevo el tracker
    delimiter = ',';
    ground_truth_new = importdata(New_GT,delimiter);
    path_mainFolder_Tracking_new = strcat(path_mainFolder_Tracking, '_',num2str(failures));
    [tracking_results_new]=...
        tracker_dsst(ground_truth_new(1,:),path_video,path_mainFolder_Tracking_new);
    
    %calculando si volvio a fallar
    [distance_precision, average_center_location_error, overlaps] = ...
        tracking_performance_measures(tracking_results_new, ground_truth_new, distance_precision_threshold);
    %Encontrando donde drafts the tracker
    first_zero=find(overlaps==0,1);
    New_start_GT = first_zero+5+New_start_GT; %para que sume los anteriores frames al GT y no coja
    %solo los iniciales sin el offset
    calculo_ciclo = ceil(New_start + (2*FrameRate));
end
average_overlap
failures
S=30
Tracker_Robustness = exp(-S*(failures/Number_Frames_Video_Original))
close all
plot(Tracker_Robustness, average_overlap,'*')
axis([0 1 0 1])
grid minor
legend('tracker DSST')
toc
