GroundTruth_WLPristine=gTruth.LabelData.a;

%%
%Esto es para que solo guarde los frames en los que ground truth, se debe
%mirar en gTruth.LabelData cuales es el intervalo de frames en los que hay
%ground Truth y colocar lo aqui abajo
% Frame1_ExisteGT=35;
% FrameEnd_ExistsgT=122;
% GroundTruth_WLPristine=GroundTruth_WLPristine_temp(Frame1_ExisteGT:FrameEnd_ExistsgT,:);
%%
%f=cell2mat(GroundTruth_WLPristine);

%% Esta parte cambia los frames en los que no haya gt por 1 1 2 2 
for i=1:size(GroundTruth_WLPristine,1)
    if isempty(GroundTruth_WLPristine{i,:})
        f(i,:)=[100 100 101 101]; %Para que no sean los mismos que los que se cambian 
        %NaN en el GT
    else 
        f(i,:)=GroundTruth_WLPristine{i,:};
    end
end
%%
Name_GroundTruth='mecal_gt.txt';
dlmwrite(Name_GroundTruth,f,'delimiter',',');