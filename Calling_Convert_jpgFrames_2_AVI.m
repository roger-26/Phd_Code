fps=30;
folder_jpg_frames = ...
    'G:\datasets\VOT2019\SequenceBallet\';
folder_tosave_video = 'G:\datasets\VOT2019\';
name_video ='SequenceBallet';
NumberOfFrames=1389;
number_zeros =7;

Convert_jpgFrames_2_AVI(fps,NumberOfFrames,number_zeros,folder_jpg_frames,folder_tosave_video,name_video);