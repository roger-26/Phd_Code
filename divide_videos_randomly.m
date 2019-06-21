function [ Training_Data,Test_Data,Training_MOS,Test_MOS] = divide_videos_randomly(dataFile, MOS_File, NumberVideosTraining)

%generating training and test set to train SVR regressor for Qualcomm LIVE dataset.

%Created by Roger Gomez Nieto - June 20,2019

%dataFile: Name of file containing data
%MOS_FIle: Name of file containing MOS_Scores
%NumberVideosTraining: Number of videos to will use for training
%Reading .mat

%A esta función le paso los .mat de una carpeta que tenga todos los videos de una distorsión, y el
%la divide aleatoriamente, dejando una matrix 3D, donde la primera dimension son cada uno de los
%videos, la segunda es el número de características por video, y la ultima es el número de features
%que extrae C3D. Para el caso de la capa fc6-1, son 4096. Se usa 28 videos para training y el resto
%para test. Sin embargo, esto se deja como un parámetro de entrada para que pueda ser modificado. 




% name_dataFile='DATA_fc6_Overlap8_YCbCr_Artifacts';
% name_MOSFile= 'MOS_fc6_Overlap8_YCbCr_Artifacts';
% aux1= load(strcat(name_dataFile,'.mat'));
% aux3=load(strcat(name_MOSFile,'.mat'));

aux1=load(dataFile);
aux3=load(MOS_File);
Artifacts_data=aux1.data;
Artifacts_MOS= aux3.MOS_fc6;
aux2= size(Artifacts_data);
Random_Numbers=randperm(aux2(1));
i_test=0;
%creating the training and test set for this distortion
for i=1:aux2(1)
    Current_Video=Random_Numbers(i);
    if i<=NumberVideosTraining
        Training_Data(i,:,:)=Artifacts_data(Current_Video,:,:);
        Training_MOS(i,1)= Artifacts_MOS(Current_Video);
    else
        i_test=i_test+1;
        Test_Data(i_test,:,:)=Artifacts_data(Current_Video,:,:);
        Test_MOS(i_test,1)= Artifacts_MOS(Current_Video);
    end
end
end