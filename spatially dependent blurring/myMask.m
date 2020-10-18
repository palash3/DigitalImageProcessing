function [bg_mask,fg_mask] = myMask(inputimg)
%UNTITLED Summary of function myMask goes here
%   This method works on applying histogram technique on color scheme.
%   What we have done is applying image binarize for 3 channel and then 
%   selecting the channel which has the least mean.
%   reason for this is, the channel which has least mean is the channel 
%   which is least used suggesting it is part of foreground.
%   a threshold is also used in case if two color channels have been used 
%   in foreground in that case we take mean for those two channel binary 
%   histogram as the final mask.
img=inputimg;
% this threshold is used to find max differece between two color channel
thres=0.02;
%applying binary histogram on all channels
BM1=imbinarize(img(:,:,1));
BM2=imbinarize(img(:,:,2));
BM3=imbinarize(img(:,:,3));
%combining all three channel histogram and finding channels that are
%dominating
bm=BM1+BM2+BM3;
[m,n,c]=size(img);
mrgb=[mean(BM1,'all'),mean(BM2,'all'),mean(BM3,'all')];
[~,I]=min(mrgb);
[~,J]=max(mrgb);
b = sort(mrgb);
b1 = b(max(1, end-1));
J2= find(mrgb==b1);
%removing channels that are dominating in background
if(abs(mrgb(J)-mrgb(I))>=thres)
   bm=bm-imbinarize(img(:,:,J));
   c=c-1;
end
if(abs(mrgb(J2)-mrgb(I))>=thres)
   bm=bm-imbinarize(img(:,:,J2));
   c=c-1;
end
%genreating mask
BM=imbinarize(bm/c);
BM=bwareafilt(BM,1);
BM=im2uint8(BM);
%output 1 background mask
bg_mask=BM;
%inverting the mask
for i=1:m
    for j=1:n
        if(BM(i,j)==255)
            BM(i,j)=0;
        else
            BM(i,j)=255;
        end
    end
end
%output 2 foreground mask
fg_mask=BM;
end