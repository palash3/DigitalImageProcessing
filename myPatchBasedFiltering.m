function myPatchBasedFiltering(ip_orig , ip_corrupted_img,ip_name,ip_h,ip_sigma)


% img = ip_img;
% imnoise(img,'gaussian',0,0.002);
corrupted = ip_corrupted_img;
% std=0.05*(max(img(:))-min(img(:)));
% corrupted =randn(size(img))*double(std);


corrupted = double(corrupted);


window_size = 21;
windowby2 = floor(window_size /2);
patch_size = 9;
patch_sizeby2 = floor(patch_size /2);
op = zeros (size(corrupted));
corrupted_padded = padarray(corrupted,[patch_sizeby2  patch_sizeby2],'symmetric');
[row , col] = size(corrupted);
sigmah = ip_sigma;
kernel = fspecial('gaussian',patch_size,sigmah) ;
% plotImage("Image kernel",kernel);
for i=1:row
    for j=1:col
% We will use corrupt_padded here to take care of boundary condition
        ipad = i+patch_sizeby2;
        jpad = j+patch_sizeby2;
        rj = corrupted_padded(ipad-patch_sizeby2:ipad+patch_sizeby2 ,jpad-patch_sizeby2:jpad + patch_sizeby2);
        windowminx = max (ipad-windowby2 ,patch_sizeby2 + 1);
        windowmaxx = min (ipad+windowby2 ,patch_sizeby2 + row);
        windowminy = max (jpad-windowby2 ,patch_sizeby2 +1);
        windowmaxy = min (jpad+windowby2 ,patch_sizeby2 +col);
        
        weightedwh = 0;
        sumwh =0;
        
        for m = windowminx: windowmaxx
            for n = windowminy: windowmaxy
                rk = corrupted_padded(m-patch_sizeby2 :m+patch_sizeby2 ,n-patch_sizeby2:n+patch_sizeby2);
                d2 = sum(sum(kernel.*double(rj-rk).*double(rj-rk)));
                wh = exp (-d2/ (ip_h*ip_h));
                weightedwh = weightedwh + (wh * corrupted_padded(m,n));
                sumwh = sumwh + wh;
            end
        end
        op(i,j) = weightedwh / sumwh;        
    end
end
op = uint8(op);
plotImage( ip_name + " h="+ip_h + " sigma  "+ sigmah + " RMSD " + rmsd_optimised(uint8(op),ip_orig) ,op);    



function op  = rmsd_optimised(A,B)
    [r , c ] = size(A);
    op = sqrt((1/(r*c))* sum(sum((A-B).*(A-B))));
end

function output = rmsd(A,B)
    [row, col] = size(A);
    
    total=0.0;
    
    for i=1:row
        for j=1:col
            total=total+sum((A(i,j)-B(i,j)).^2,'all');
        end
    end
    output=sqrt(double(total)./double(row*col));
    
end

end
