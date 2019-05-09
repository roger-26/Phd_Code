clc;
close all;
clear all;

gt = importdata('pedestrian1_gt.txt');
struck_log =importdata('log_pedestrian1_STRUCK_Roger.txt');
nd=size(gt,1)

ovmax=0;
tp=zeros(nd,1);
fp=zeros(nd,1);
npos=nd;
ovmax=-inf;

minoverlap=0.5;
for d=1:nd

    % assign detection to ground truth object if any
    bb=struck_log(d,:);
        bbgt=gt(d,:);
        bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
        iw=abs(bi(3)-bi(1)+1);
        ih=abs(bi(4)-bi(2)+1);             
            % compute overlap as area of intersection / area of union
            ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
               (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
               iw*ih;
            ov=iw*ih/ua;
       
    % assign detection as true positive/don't care/false positive
    if ov>=minoverlap
                tp(d)=1;            % true positive
    else
        fp(d)=1;                    % false positive
    end
end

% compute precision/recall
fp=cumsum(fp);
tp=cumsum(tp);
rec=tp/npos;
prec=tp./(fp+tp);
% compute average precision
ap=0;
for t=0:0.1:1
    p=max(prec(rec>=t));
    if isempty(p)
        p=0;
    end
    ap=ap+p/11;
end


   
    plot(rec,prec,'-');
    grid;
    xlabel 'recall'
    ylabel 'precision'