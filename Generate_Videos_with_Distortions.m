%Genera unos videos distorsionados a partir de videos pristinos
%para ayuda de uso ver la función Distort_Video

addpath 'C:\Dropbox\git'
Path_Input = 'G:\datasets\Videos_CarlosQuiroga\Pristine Videos\';



Path_Output = 'G:\datasets\Videos_CarlosQuiroga\saltpepper_distortion\low\';
Distortion = 'salt & pepper';
Level= 'low';

parfor i=1:70
    i
    name_video_ciclo = strcat('video',num2str(i),'.mp4');
    Distort_Video(Path_Input, Path_Output, name_video_ciclo, Distortion, Level)
end

Path_Output = 'G:\datasets\Videos_CarlosQuiroga\saltpepper_distortion\medium\';
Distortion = 'salt & pepper';
Level= 'medium';

parfor i=1:70
    i
    name_video_ciclo = strcat('video',num2str(i),'.mp4');
    Distort_Video(Path_Input, Path_Output, name_video_ciclo, Distortion, Level)
end


Path_Output = 'G:\datasets\Videos_CarlosQuiroga\saltpepper_distortion\high\';
Distortion = 'salt & pepper';
Level= 'high';

parfor i=1:70
    i
    name_video_ciclo = strcat('video',num2str(i),'.mp4');
    Distort_Video(Path_Input, Path_Output, name_video_ciclo, Distortion, Level)
end



