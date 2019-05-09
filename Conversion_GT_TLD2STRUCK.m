clc;
close all;
clear all;

gt_TLD1 = importdata('tld.txt');
gt_TLD=gt_TLD1(:,1:4);
gt_STRUCK=gt_TLD;
for i=1:size(gt_TLD,1)
    gt_STRUCK(i,3)=abs(gt_TLD(i,3)-gt_TLD(i,1));
    gt_STRUCK(i,4)=abs(gt_TLD(i,4)-gt_TLD(i,2));
end

dlmwrite('TLD_01_david.txt',gt_STRUCK)

