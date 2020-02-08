clc;
name_video = '1024_BadmintonAtBalboa_OppoFined7_VID20150512060558';
v = VideoReader(strcat(name_video,'.avi'))
vid_frames = read(v);
save(strcat('LIVEQUALCOMM_MAT\color\',name_video,'.mat'),'vid_frames','-v7.3','-nocompression');
% clear all;
% clc
% load('A001.mat')