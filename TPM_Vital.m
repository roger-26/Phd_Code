clear all;
clc;
close all;

addpath('../utils');
addpath('../models');
addpath('../vital');

run ../matconvnet/matlab/vl_setupnn ;

global gpu;
gpu=true;
    
test_seq='001Pri_IndPW_FQ_C4';
conf = genConfig('otb',test_seq);

net=fullfile('../models/otbModel.mat');

result = vital_run(conf.imgList, conf.gt(1,:), net, true);

%% calculating performance measures

pd_boxes=result;
gt_boxes=conf.gt;
distance_precision_threshold=20;
[distance_precision, average_center_location_error, overlaps] = ...
tracking_performance_measures(pd_boxes,gt_boxes,distance_precision_threshold);
average_overlap = mean (overlaps);

%Encontrando donde drafts the tracker
first_zero=find(overlaps==0,1)
%contando que existan al menos dos ceros
idx=overlaps==0;
number_original_failures=sum(idx(:))
Number_Frames_Video_Original=length(gt_boxes);
failures=0;
new_start=0
while (first_zero~= 0) & (first_zero <= Number_Frames_Video_Original-10) & number_original_failures>1
    failures=failures+1
    new_start=first_zero+5+new_start
    gt_boxes_new=gt_boxes(new_start:end,:);
    seq_new=conf;
    seq_new.len=length(gt_boxes_new);
    seq_new.init_rect=gt_boxes_new(1,:);
    seq_new.imgList=conf.imgList(:,new_start:end);
    close all;
    results_new = vital_run(seq_new.imgList, gt_boxes_new(1,:), net, true);
    
    [distance_precision, average_center_location_error, overlaps_new] = ...
    tracking_performance_measures(results_new,gt_boxes_new,distance_precision_threshold);
    idx=overlaps_new==0;
    number_original_failures=sum(idx(:))
%Encontrando donde drafts the tracker
    first_zero=find(overlaps_new==0,1);
end;
failures
S=30;
Tracker_Robustness = exp(-S*(failures/Number_Frames_Video_Original))
average_overlap 