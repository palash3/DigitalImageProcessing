%% MyMainScript

tic;
%% Your code here
close all;
clear;

input_image_flower = imread("../data/flower.jpg");
alpha_flower = 20;
[fmask , bmask] = myMask(input_image_flower);
plotImage("Original Image flower",input_image_flower);
plotImage("Mask for flower",fmask);
[rowb ,colb ,color] = size(input_image_flower);
[out_flower , rmatrix ]= mySpatiallyVaryingKernel(alpha_flower,input_image_flower,fmask);
figure("Name", "Contour plot"); contour(flipud(rmatrix));
kernel_radii = [.2:.2:1] * alpha_flower;
for k = 1 : size(kernel_radii')
    plotImage("Blurring kernel alpha= "+kernel_radii(k), fspecial('disk',kernel_radii(k)));
end

plotImage("Output flower alpha = "+ alpha_flower,out_flower);


input_image_bird = imread("../data/bird.jpg");
alpha_bird = 40;
[fmask , bmask] = myMask(input_image_bird);
plotImage("Original Image flower",input_image_bird);
plotImage("Mask for flower",fmask);
[rowb ,colb ,color] = size(input_image_bird);
[out_bird , rmatrix ]= mySpatiallyVaryingKernel(alpha_bird,input_image_bird,fmask);
figure("Name", "Contour plot"); contour(flipud(rmatrix));
kernel_radii = [.2:.2:1] * alpha_bird;
for k = 1 : size(kernel_radii')
    plotImage("Blurring kernel alpha= "+kernel_radii(k), fspecial('disk',kernel_radii(k)));
end

plotImage("Output flower alpha = "+ alpha_bird,out_bird);


toc;