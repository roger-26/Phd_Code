clc;
clear all;
close all;
% Browse Video File :
% [ video_file_name,video_file_path ] = uigetfile({'*.mov'});
video_file_name = '046Exp_OutRK_FQ_C4_1280x720.avi';
% video_file_path = 'C:\Dropbox\Javeriana\Courses\DSP\Set_Roger\'
video_file_path = 'C:\Dropbox\Javeriana\Courses\DSP\Set2\Videos\'
% if(video_file_path==0)
%     return;
% end
% Output path
output_image_path = fullfile(video_file_path,[video_file_name(1:strfind(video_file_name,'.')-1),'.mp4'])
% mkdir(output_image_path);

input_video_file = [video_file_path,video_file_name];
% Read Video
videoFReader = VideoReader(input_video_file);
% Write Video
videoFWrite = VideoWriter(output_image_path,'MPEG-4');
videoFWrite.FrameRate = videoFReader.FrameRate;
open(videoFWrite);

for count = 1:abs(videoFReader.Duration*videoFReader.FrameRate)
    disp(count);
    key_frame = read(videoFReader,count);
    writeVideo(videoFWrite,key_frame);
end
% Release video object
%close(videoFReader);
close(videoFWrite);

disp('COMPLETED... (-_-)');