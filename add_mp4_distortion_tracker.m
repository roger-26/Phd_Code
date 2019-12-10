
function [] = add_mp4_distortion_tracker(num_video,level_distortion)
cd '/media/javeriana/HDD_4TB/AppDrivenTracker/videos70_025resolution/'
%% convert video 2 avi
Video_Name= strcat(' video',num2str(num_video));

switch level_distortion
    case 'high'
        bitrate = 100000;
    case 'medium'
        bitrate = 1e6/5;
    case 'low'
        bitrate = 1e7;
end
%para que la frame rate se configure en 10 -r 10
execute_string= strcat(['ffmpeg -i ',Video_Name,'.mp4 -r 30 -b:v ',num2str(bitrate), Video_Name,'.avi'])

system(execute_string)
%% cargar el video
%directorio donde esta el codigo source de python
cd '/home/javeriana/PycharmProjects/readvideo/'
system('python read_video.py 3')
%pasar al formato del tracker. 

end
