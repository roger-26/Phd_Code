clear all;
close all;
clc;
parfor i=13:16
    start_video = (200*(i-1))+1
    last_video = 200*i
    disp(start_video)
   [name_to_save_mat(i)]=executing_TLVWM_Features_PerVideo_AD_VSD(start_video,last_video); 
end