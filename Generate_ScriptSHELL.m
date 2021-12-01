clc
D='F:\ADVSD_Video_frames';
% D = 'F:\datasets\VOT2020-ST';
%S = dir(fullfile(D,'*.xyz')); % specify the file extension to exclude directories
files=dir(D)
dirFlags = [files.isdir]
folders_existing = files(3:end,:);
% for i=0:size(folders_existing{:}.name)
folders_existing2 = struct2table(folders_existing);
folders_existing3=folders_existing2(:,1)

videos_selected = ...
    csvimport...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/videos_MFTMayor05_30FPS_1385.csv');
    number_current_video=videos_selected(1);
    letras=char(number_current_video)
    [filepath,name_individual_video,ext] =fileparts(letras);
  
    
FilePath=('C:\Dropbox\Public/shell.txt');
fid = fopen(FilePath,'w');
for i=1:size(videos_selected,1)
    
      number_current_video=videos_selected(i);
    letras=char(number_current_video)
    [filepath,name_individual_video,ext] =fileparts(letras);
    command1=strcat("cd ",name_individual_video)
%     command1=strcat("cd ",table2cell( folders_existing3(i,1)))
    fprintf(fid,'%s\n', command1);
    
    command2=strcat("sudo mv groundtruth.txt groundtruth_rect.txt")
    fprintf(fid,'%s\n', command2);
    
%     command3=strcat("mv img/* .")
%     fprintf(fid,'%s\n', command3);
%     
%     
%     command4=strcat("sudo rm -r img/")
%     fprintf(fid,'%s\n', command4);
    
       command5=strcat("cd ..")
    fprintf(fid,'%s\n', command5);
end
fclose(fid)
