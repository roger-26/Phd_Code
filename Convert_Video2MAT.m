clc;

% 
% avi_files = dir('*.avi');
% 
% 
% 
% for i=1:34
%     aux1=avi_files(i).name; %get the name of video of the Original MOS
% aux3=char(aux1); %
% C = strsplit(aux3,'.');%separa por el punto para que no guarde como nombre la extensi
% name_video=char(C(1));
% 
% %     name_video = '0912_Burgers_Note4_20150912_144558';
%     v = VideoReader(strcat(name_video,'.avi'))
%     vid_frames = read(v);
%     save(strcat('F:\datasets\LIVE_QUALCOMM_MAT\Exposure\',name_video,...
%         '.mat'),'vid_frames','-v7.3','-nocompression');
% end

tic
     name_video = '1024_BadmintonAtBalboa_LGG2_CAM00888';
    v = VideoReader(strcat(name_video,'.avi'))
    vid_frames = read(v);
    save(strcat('F:\datasets\LIVE_QUALCOMM_MAT\color\',name_video,...
        '.mat'),'vid_frames','-v7.3','-nocompression');
toc
% clc
% load('A001.mat')
