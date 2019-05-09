
% This demo script runs the C-COT on the included "Crossing" video.
clc
clear all
% Add paths
setup_paths();

% Load video information
video_path = 'sequences/043Exp_OutFIG_FQ_C3'
[seq, ground_truth] = load_video_info(video_path);

% Run C-COT
results = testing(seq);

%% medidas de rendimiento

pd_boxes=results.res;
gt_boxes=ground_truth;
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
while (first_zero~= 0) & (first_zero <= Number_Frames_Video_Original-10) & number_original_failures>1
    failures=failures+1
    new_start=first_zero+5+new_start
    gt_boxes_new=gt_boxes(new_start:end,:);
    seq_new=seq;
    seq_new.len=length(gt_boxes_new);
    seq_new.init_rect=gt_boxes_new(1,:);
    seq_new.s_frames=seq.s_frames(new_start:end,:);
    close all;
    results_new = testing(seq_new);
    
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