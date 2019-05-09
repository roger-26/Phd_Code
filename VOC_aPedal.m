clc;
close all;
clear all;
%calculate success plot and precision plot of tracking results.

name='Police Video';
Size_Font=24;  %size letters axis and title plot

Name_Tracker='STRUCK';

gt_Initial = importdata('mecal_gt.txt');
% logpedestrianSTRUCKRoger1=importdata('carchase_tracker_bbox_pristine.txt');
Tracker_Results = importdata('STRUCK_mecal.txt');

%% Esto es si se deben llenar con ones las demas posiciones de un resultado
%del tracker

%SI ES TLD SE DEBE CONVERTIR PRIMERO AL FORMATO ESTÁNDAR DE RESULTADO BB

% Number_Lines=size(gt_Initial,1);%número de filas en el GT
% Tracker_Results1=ones(Number_Lines,4);
% for i=1:size(Tracker_Results,1)
%  Tracker_Results1(i,:)=Tracker_Results(i,:);
% end
%  Tracker_Results=Tracker_Results1;

%%

%  gt_Initial = importdata('GT_STRUCK_pedestrian1.txt');
% % logpedestrianSTRUCKRoger1=importdata('pedestrian1_tracker_bbox_pristine.txt');
% logpedestrianSTRUCKRoger1=importdata('TLD_Pedestrian_FormatoANchoAlto.txt');

% gt_Initial = importdata('GT_STRUCK_David.txt');
% logpedestrianSTRUCKRoger1=importdata('TLD_David_FormatoANchoAlto.txt');
% logpedestrianSTRUCKRoger1=importdata('david_tracker_bbox_pristine.txt');


%  gt_Initial= importdata('GT_STRUCK_JUMPING.txt');
% logpedestrianSTRUCKRoger1=importdata('jumping_tracker_bbox_pristine.txt');
%  logpedestrianSTRUCKRoger1=importdata('TLD_JUmping_FormatoANchoAlto.txt');

%cleaning NaN



if (size(gt_Initial,1)~=size(Tracker_Results,1))
   
 logpedestrianSTRUCKRoger=ones(size(gt_Initial,1),4);   
    
 
disp('GT & tracker_log do not have same size');
logpedestrianSTRUCKRoger(1:size(Tracker_Results),1:4)=Tracker_Results;
% gt_Initial=gt_Initial1(1:size_minnor,:);
else 
    logpedestrianSTRUCKRoger=Tracker_Results;
end
    cont =1;
    % si hay nan no guarda ni gt ni log de tracking. Al final los
    for i=1:size(gt_Initial,1)
        if (isnan(gt_Initial(i,1)))
            Message=['In GT there are NaN in position ',num2str(i)];
            disp(Message);
        else
            gt(cont,:)=gt_Initial(i,:);
            Log_Tracking1(cont,:)=logpedestrianSTRUCKRoger(i,:);
            cont=cont+1;
        end
    end 
    
    %if exist nan in log tracker for bb area =1
    for i=1:size(Log_Tracking1,1)
        if (isnan(Log_Tracking1(i,1)))
            Message=['There are NaN tracker log in position ',num2str(i)];
            disp(Message);
            Log_Tracking(i,:)=[1,1,2,2];
        else
            Log_Tracking(i,:)=Log_Tracking1(i,:);
        end
    end
    
    
    
    Threshold_Vector=0.05:0.05:1;
    
    for Cont_Threshold=1:size(Threshold_Vector,2)
        Tp=0;
        Fp=0;
        for i=1:size(gt,1)
            
            %Compute bounding box overlap ratio
            OverlapRatio(i) = bboxOverlapRatio(gt(i,:),Log_Tracking(i,:),'Union');
            if OverlapRatio(i)>Threshold_Vector(Cont_Threshold)
                Tp=Tp+1;
            else
                Fp=Fp+1;
            end
            
        end
        Accuracy_Plot(Cont_Threshold)=Tp/size(gt,1);
    end
    subplot(121)
    plot(Threshold_Vector,Accuracy_Plot,'LineWidth',4)
    hold on
    plot(0.25*ones(size(Threshold_Vector)),Accuracy_Plot,'-r');
    grid minor
    xlabel('Overlap threshold');
    ylabel('Success rate');
    set(gca,'fontsize',Size_Font)
    axis([0.05 1 0 1])
    %Calculando integración numerica para hallar area bajo la curva
    AUC_success_Plot = trapz(Threshold_Vector(1:5),Accuracy_Plot(1:5));
    title([name,' - ',Name_Tracker, '  AUC = ',num2str(AUC_success_Plot)])
    %% Precision plot
    Threshold_Euclidean_distance=1:0.05:50;
    for Cont_Threshold=1:size(Threshold_Euclidean_distance,2)
        Tp=0;
        Fp=0;
        for i=1:size(gt,1)
            %Compute bounding box overlap ratio
            Center_gt(i,1)=gt(i,1)+(gt(i,3)/2);
            Center_gt(i,2)=gt(i,2)+(gt(i,4)/2);
            Center_BBTracker(i,1)=Log_Tracking(i,1)+(Log_Tracking(i,3)/2);
            Center_BBTracker(i,2)=Log_Tracking(i,2)+(Log_Tracking(i,4)/2);
            Distances(i)=...
                sqrt( ((Center_gt(i,1)-Center_BBTracker(i,1))^2)+((Center_gt(i,2)-Center_BBTracker(i,2))^2));
            if Distances(i)<Threshold_Euclidean_distance(Cont_Threshold)
                Tp=Tp+1;
            else
                Fp=Fp+1;
            end
        end
        Accuracy_Plot_Precision(Cont_Threshold)=Tp/size(gt,1);
    end
    subplot(122)
    plot(Threshold_Euclidean_distance,Accuracy_Plot_Precision,'LineWidth',4)
    hold on
    plot(20*ones(size(Threshold_Euclidean_distance)),Accuracy_Plot_Precision,'-r');
    grid minor
    xlabel('Location error threshold');
    ylabel('Precision');
    set(gca,'fontsize',Size_Font)
    axis([0 50 0 1])
    
    %Calculando integración numerica para hallar area bajo la curva
    %Solo se calculan los valores que esten por debajo del umbral de 20 px de
    %distancia euclideana
    AUC_precision_Plot = trapz(Threshold_Euclidean_distance(1:381),Accuracy_Plot_Precision(1:381));
    title([name,' - ', Name_Tracker,' - AUC = ',num2str(AUC_precision_Plot)])