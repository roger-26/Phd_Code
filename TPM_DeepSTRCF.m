clc;
close all;
clear all;
% This demo script runs the STRCF tracker with deep features on the
% included "Human3" video.

% Add paths
setup_paths();

%  Load video information
base_path  =  './sequences';
video  = choose_video(base_path);
video_path = [base_path '/' video];
% esto es para cuando no se tiene o no se quiere todo el ground truth de la
% imagen, entonces se le mete el nùmero de imàgenes de la secuencia y solo
% se mete la primer anotaciòn dle bounding box



length_sequence= 130;
[seq, gt_boxes] = load_video_info(video_path,length_sequence);



% Run STRCF
%results = run_STRCF(seq);
results = run_DeepSTRCF(seq);
Name_Results=strcat(video,'results_DeepSTRCF.txt');
dlmwrite(Name_Results,results.res,'delimiter',',');

pd_boxes = results.res;
thresholdSetOverlap = 0: 0.05 : 1;
success_num_overlap = zeros(1, numel(thresholdSetOverlap));
res = calcRectInt(gt_boxes, pd_boxes);
for t = 1: length(thresholdSetOverlap)
    success_num_overlap(1, t) = sum(res > thresholdSetOverlap(t));
end
cur_AUC = mean(success_num_overlap) / size(gt_boxes, 1);
FPS_vid = results.fps;
display([video  '---->' '   FPS:   ' num2str(FPS_vid)   '    op:   '   num2str(cur_AUC)]);

%% Calculating performance measures A-R plot
distance_precision_threshold=20;
[distance_precision, average_center_location_error, overlaps] = ...
tracking_performance_measures(pd_boxes,gt_boxes,distance_precision_threshold);
average_overlap = mean (overlaps);

%Encontrando donde drafts the tracker
first_zero=find(overlaps==0,1)
%contando que existan al menos dos ceros
idx=overlaps==0;
number_original_failures=sum(idx(:))

Number_Frames_Video_Original=seq.len;
failures=0;
new_start=0
while (first_zero~= 0) & (first_zero <= Number_Frames_Video_Original-10)...
        & number_original_failures>1
    failures=failures+1
    new_start=first_zero+5+new_start
    gt_boxes_new=gt_boxes(new_start:end,:);
    seq_new=seq;
    seq_new.len=length(gt_boxes_new);
    seq_new.init_rect=gt_boxes_new(1,:);
    seq_new.s_frames=seq.s_frames(new_start:end,:);
    close all;
    results_new = run_DeepSTRCF(seq_new);
    
    [distance_precision, average_center_location_error, overlaps_new] = ...
    tracking_performance_measures(results_new.res,gt_boxes_new,distance_precision_threshold);
    idx=overlaps_new==0;
    number_original_failures=sum(idx(:))
%Encontrando donde drafts the tracker
    first_zero=find(overlaps_new==0,1);
end;
failures
S=30;
Tracker_Robustness = exp(-S*(failures/Number_Frames_Video_Original))
average_overlap 