clear all;
close all
clc
name='Features_C3D_Qualcomm_averaged_AllDistortions';
aux=load(strcat(name,'.mat'));
data_no_processed= aux.All_data;
maximum_number_max = max(data_no_processed(:))

data_normalized=data_no_processed./maximum_number_max;
name_to_save=strcat(name,'_NORMALIZED.mat');
save(name_to_save,'data_normalized');
