clc
path_frames = 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0275Pri_IndWL_C1\img';
path_video = ...
'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0275Pri_IndWL_C1\0275Pri_IndWL_C1.mp4'
Initial_Frame = 0
change_size_flag = 0;
Desired_Type_File = 'png'
[Number_Of_Frames] = ...
Generate_Frames_From_Video(path_frames,path_video, Desired_Type_File,Initial_Frame, change_size_flag)