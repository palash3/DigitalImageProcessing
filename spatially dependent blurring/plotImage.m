function fig = plotImage(heading,img)
    figure ("Name" ,heading);
    myNumOfColors = 200;
    myColorScale = [ [0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];
    %m = gray;
    imagesc(img);
    title(heading);
    colormap (myColorScale);
    daspect([1 1 1]);
    axis tight;
    colorbar;
    saveas(gcf,strtrim(heading)+".jpg");
end