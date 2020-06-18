clear all;

    k=12;         %Numero del video
    videoPart=2; %Parte del video
    scale=0.25;   %Scale Video Size Factor
    parts=3; %Numero de partes en la cual sera dividido el video
    
    if videoPart>parts
        videoPart=parts;
    end
    
    vid=strcat('video',num2str(k));    
    gtP_complete=load(strcat(vid,'/groundtruth_rect.txt')); 
    gtP_complete=round(gtP_complete*scale);
    
    
    InitialFrame=1;
    endParts=ones(1,parts+1);
    partial_part=round(size(gtP_complete,1)/parts);
    aux=0;
    
    for i=2:parts
        aux=aux+partial_part;
        endParts(i)=aux;
    end
        endParts(parts+1)=size(gtP_complete,1);
    
    
    vid_name=strcat('vid_pristine',num2str(k),'_',num2str(videoPart),'_',num2str(parts),'_',num2str(100*scale));
    
    auxv=1;
    for i=endParts(videoPart):endParts(videoPart+1)
        j=strcat('0000',num2str(i));
            e=size(j,2);

            img = imread(strcat(vid,'/',j(1,e-3:e),'.png'));
            J = imresize(img, scale);
            frames(:,:,:,auxv)=J;
            auxv=auxv+1;
    end

        gtP=gtP_complete(endParts(videoPart):endParts(videoPart+1),:);
    
    save(strcat('D:/Javeriana_OTV/AppDrivenTracker/videos/',vid_name,'.mat'),'frames','-v7.3');
    save(strcat('D:/Javeriana_OTV/AppDrivenTracker/videos/',vid_name,'_gt.mat'),'gtP');