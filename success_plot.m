function[AUC,Success_rate] = success_plot(GT,BB_tracker,name_video,resolution_plot,color)
%This function returns the Area Under the Curve AUC of success plot.
%Success_rate is the values for each threshold, according to the tracker
%performance

%Success plot is a performance measure for tracking.
%author: Roger Gomez Nieto
%email: rogergomez@ieee.org
%date: april 9,2020
%Parameters:
%GT is a matrix Mx4 containing the Ground Truth to evaluate tracker
%   performance. X1 Y1 width height. M is the number of frames of video. 
%BB_tracker is a matrix Mx4 with the results of tracker to evaluate. 
%name_video is the string to show in the title identifying the video
%   evaluated.
%resolution_plot is a float number with the increment in range 0 to 1 for
%   threshold to evaluate overlap. default is 0.01 for the plot have 100
%   points

%color: 'r' --> red   'g'--> green


    length_sequence = size(GT,1);
    Overlap_Per_frame = bboxOverlapRatio(BB_tracker,GT);
    Overlap_Percentage = ...
    Overlap_Per_frame(sub2ind(size(Overlap_Per_frame),1:size(Overlap_Per_frame,1),1:size(Overlap_Per_frame,2)));
    cont=0;
    for i= resolution_plot:resolution_plot:1
        cont=cont +1;
        ejex(cont)=i;
        NormalCount(cont) = sum(Overlap_Percentage>i);   
    end
    Success_rate = NormalCount/length_sequence;
    plot(Success_rate,ejex,color,'LineWidth',3)
    AUC= trapz(ejex,Success_rate);
    grid minor
    ylabel('Success rate','FontSize',28);
    xlabel('Overlap threshold','FontSize',28);
    axis([0 1 0 1]);
    set(gca,'FontSize',18);
end