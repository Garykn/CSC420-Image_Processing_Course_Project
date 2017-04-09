function [outputImage ] = personBackgroundDetector(truths)
%PERSONBACKGROUNDDETECTOR Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('./images'));
addpath(genpath('./labels'));
images = dir('images/*.jpg');
%labelImages = dir('labels/*clothes.png');
for all= 1: 30
    outputImage = zeros(600, 400);
    currentImage = imread(images(all).name);
    jointPoints = truths(all).pose.point;
    [superPixels,NumLabels] = superpixels(currentImage,250);
    [rowsize, columnsize] = size(superPixels);
    BW = boundarymask(superPixels);
    superPixelIndices = label2idx(superPixels);
    superPixelCount = length(superPixelIndices);
    imshow(imoverlay(currentImage,BW,'cyan'),'InitialMagnification',67);
    hold on;
    labels = [];
    
    
    points=[[1,2];[2,3];[3,4];[4,5];[5,6];[7,8];[8,9];[9,10];[10,11];[11,12];[13,14]; [3,9]; [3,13]; [3,10]; [4,9]; [4,13]; [4,10];[10,14];[9,14]];
    xx= [];
    yy = [];
    for i = 1:length(points)
        %fl  source : https://www.mathworks.com/matlabcentral/fileexchange/29104-get-points-for-a-line-between-2-points
        % finds all points on line from point a to b
        [x_p,y_p]=findLines([jointPoints(points(i,1),1),jointPoints(points(i,1),2)],[jointPoints(points(i,2),1),jointPoints(points(i,2),2)],100);
        xx = [xx ,round(x_p)];
        yy = [yy , round(y_p)];
    end
    % finds all labels mapped to the points
    for i= 1: length(xx)
        if ~isnan(yy(i)) && ~isnan(xx(i))
            labels = [labels superPixels(yy(i), xx(i))];
        end
    end
    labels = unique(labels);
    outputImage = zeros(600, 400);
    
    display(labels)
    % labels all the super pixels that crosses the lines
    for y = 1:600
        for x = 1 : 400
            if any( labels == superPixels(y,x))
                outputImage(y,x)= 1;
            end
        end
    end
    
    imagesc(outputImage);
    imwrite(outputImage,images(all).name, 'jpg');
    display(labels)
end
end

