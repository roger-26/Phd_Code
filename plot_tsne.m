

f_num = 297;

load('features_Ma_Yang_whole.mat','image_features');
load('scores_ma_yang.mat','ma_yang_sub_scores');
load('features_Pristine_whole.mat','pristine_features')
% load('features_Ours_whole.mat','ours_features')
% load('scores_new_database.mat','mean_scores')

% load(file)
% 
% pr_features = select_pristine(pristine,'BLi',0,0);

% c1 = [];
% c2 = [];
% c3 = [];

% 
% images_ft = zeros(f_num,1620);
% 

randset = 1:30;
image_index = [];
for k = 0:2
    for n = 1:30
        image_index = union(image_index,randset(n)+30*k:30*6:1620);
    end
end

for n = 1:810
    if ma_yang_sub_scores(image_index(n)) <= 6.1
        c1 = [c1 n];
    elseif ma_yang_sub_scores(image_index(n)) <= 7.75
        c2 = [c2 n];
    else
        c3 = [c3 n];
    end
    
end

Y = tsne([image_features pristine_features]','distance','Mahalanobis');
% Y = tsne([ours_features pristine_features]','distance','seuclidean');

figure();
plot(Y(image_index(c1),1),Y(image_index(c1),2),'b.')
hold on
plot(Y(image_index(c2),1),Y(image_index(c2),2),'r.')
plot(Y(image_index(c3),1),Y(image_index(c3),2),'k.')
plot(Y(1621:end,1),Y(1621:end,2),'c.')
title('3')

% c1 = [];
% c2 = [];
% c3 = [];
% 
% images_ft = zeros(f_num,640);
% 
% for n = 1:96
%     if mean_scores(n) <= 41
%         c1 = [c1 n];
%     elseif mean_scores(n) <= 55
%         c2 = [c2 n];
%     else
%         c3 = [c3 n];
%     end
%     
% end
% 
% for n = 129:640
%     if mean_scores(n) <= 41
%         c1 = [c1 n];
%     elseif mean_scores(n) <= 55
%         c2 = [c2 n];
%     else
%         c3 = [c3 n];
%     end
%     
% end
% 
% figure();
% plot(Y(c1,1),Y(c1,2),'b.')
% hold on
% plot(Y(c2,1),Y(c2,2),'r.')
% plot(Y(c3,1),Y(c3,2),'k.')
% plot(Y(641:end,1),Y(641:end,2),'c.')
% title('3')