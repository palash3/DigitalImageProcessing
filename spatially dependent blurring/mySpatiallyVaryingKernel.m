function [op , mask_dist] =  mySpatiallyVaryingKernel(alpha,img,foreground_mask)
    mask_dist = bwdist(foreground_mask);
    [row, col , color] = size(img);
    padded_img = padarray(img,[alpha alpha],0,"both");
    
    masks = {};
    for m = 1:alpha
        masks{m} = fspecial('disk',m);
    end
    
    for i=1:row
        for j=1:col
            dist = double(min(mask_dist(i,j) , alpha));
            if dist==0
                continue
            end
            ipad = i+alpha;
            jpad = j+alpha;
            mask = masks{round(dist)};
            min_i = max(1,ipad-round(dist));
            max_i = min(row+2*alpha,ipad+round(dist));
            min_j = max(1,jpad-round(dist));
            max_j = min(col+2*alpha,jpad+round(dist));
            for c = 1:color
                tp_img = padded_img (min_i:max_i,min_j:max_j,c);
                tp_op_img = double(tp_img) .* mask;
%                 padded_img(min_i:max_i,min_j:max_j,c) = uint8(tp_op_img);
                padded_img(ipad,jpad,c)= sum(tp_op_img(:));
            end
        end
    end
    op(:,:,1) = padded_img(alpha : row+alpha-1,alpha:col+alpha-1,1);
    op(:,:,2) = padded_img(alpha : row+alpha-1,alpha:col+alpha-1,2);
    op(:,:,3) = padded_img(alpha : row+alpha-1,alpha:col+alpha-1,3);
    for i=1:row
        for j=1:col
            if (mask_dist(i,j) == 0)
               for c = 1:color
                   op(i,j,c) = img(i,j,c);
               end
            end
        end
    end
end