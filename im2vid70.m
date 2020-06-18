clear all;

Fr=0.5; %Factor of image resize
for k=1:2
    
    vid=strcat('video',num2str(k));
    vid_name=strcat('05vid_pristine',num2str(k));
    %vid=vid(1,end-2:end);
    
    gtP=load(strcat(vid,'/groundtruth_rect.txt'));    
    gtP=round(gtP*Fr);
    
    for i=1:size(gtP,1)
        j=strcat('0000',num2str(i));
            e=size(j,2);

            img = imread(strcat(vid,'/',j(1,e-3:e),'.png'));
            J = imresize(img, Fr);
            frames(:,:,:,i)=J;      
    end

    
    save(strcat('D:/Javeriana_OTV/AppDrivenTracker/videos/',vid_name,'.mat'),'frames','-v7.3');
    save(strcat('D:/Javeriana_OTV/AppDrivenTracker/videos/',vid_name,'_gt.mat'),'gtP');
end