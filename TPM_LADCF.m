%%  demo for Learning Adaptive Discriminative Correlation Filter via 
%   Temporal Consistency Preserved Feature Selection Embedded Visual Tracking
close all;
clc;
clear all;

% Add paths
setup_paths();

%  Load video 
base_path  = './sequences';
video = choose_video(base_path);
video_path = [base_path '/' video];
[seq, gt_boxes] = load_video(video_path,video);

% Run Hand-crafted feature based LADCF on cpu
results = run_LADCF_HC(seq);

%results
pd_boxes = results.res;
Name_Results=strcat(video,'results_LADCF.txt');
dlmwrite(Name_Results,results.res,'delimiter',',');

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
while (first_zero~= 0) & (first_zero <= Number_Frames_Video_Original-10) & number_original_failures>1
    failures=failures+1
    new_start=first_zero+5+new_start
    gt_boxes_new=gt_boxes(new_start:end,:);
    seq_new=seq;
    seq_new.len=length(gt_boxes_new);
    seq_new.init_rect=gt_boxes_new(1,:);
    seq_new.s_frames=seq.s_frames(new_start:end,:);
    close all;
    results_new = run_LADCF_HC(seq_new);
    
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