clc;
close all;
clear all;

p = 'F:\\Videos_1_2_resolution\\';
save_path = 'C:\Users\roger\Documents\01LADCF\\results\\1_2_New\\';

addpath 'C:\Dropbox\git\'

cd 'C:\Users\roger\Documents\01LADCF'
%Este código ejecuta el tracker LADCF de forma paralela, y guarda los
%resultados de cada una de sus iteraciones que corresponde a un video. Se
%debe guardar en formato .mat
vids = dir(p);
vids = vids(3:end);


% poolobj = gcp;
% addAttachedFiles(poolobj,{'parsave.m'})

for i = 61:size(vids,1)
    t_i= datetime;
    disp(vids(i).name)
    
    close all
    % deblurred videos
    Sequences_name = vids(i).name;
    ground_truth = dlmread([p '\\' Sequences_name '\\groundtruth.txt']);
    
    [trackerEst, pfps] = LADCF_tracker(p,Sequences_name,ground_truth);
    %     save([save_path Sequences_name],'ground_truth','trackerEst','pfps')
    t_f=datetime;
    time_tracker=seconds(t_f-t_i)
    
%     save(strcat('C:\Users\roger\Documents\01LADCF\results\1_2_New\',Sequences_name,'.mat'),trackerEst,time_tracker);
    
    %Se usa para guardar los resultados de cada una de las iteraciones de
    %un ciclo parfor paralelo
    parsave(strcat('C:\Users\roger\Documents\01LADCF\results\1_2_New\',Sequences_name,'.mat'),trackerEst,time_tracker);
end