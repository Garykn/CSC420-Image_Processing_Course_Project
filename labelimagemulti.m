function labelmap = labelimagemulti(TrainedSVM, img)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('./images'));
addpath(genpath('./labels'));
images = dir('images/*.jpg');
labelImages = dir('labels/*clothes.png');

labels = {};
features = [];


[superPixels,NumLabels] = superpixels(img,200);
[rowsize, columnsize] = size(superPixels);

superPixelIndices = label2idx(superPixels);
superPixelCount = length(superPixelIndices);
outputImage = zeros(600, 400);

for j=1:superPixelCount
    x_left = min(mod(superPixelIndices{j}, rowsize) );
    x_right = max(mod(superPixelIndices{j}, rowsize) );
    
    y_min =  min(superPixelIndices{j}/rowsize) + 1;
    y_max =  max(superPixelIndices{j}/rowsize) + 1;
    
    y_center = floor(x_left + (x_right - x_left)/2);
    x_center = floor(y_min + (y_max - y_min)/2);
    
    jointPoints = truths(i).pose.point;
    
    if x_center  < jointPoints(1,1)-40 || x_center  > jointPoints(1,1)+40
        continue;
    end

    
    if x_center-12 <= 0 || x_center+12 > 400 || y_center-12 <= 0 || y_center+12 > 600
        continue;
    end
    feats2 = extractLBPFeatures(rgb2gray(currentImage(y_center-10: y_center+10, x_center-10: x_center+10, 1:3)));
    [feats, validPoints] = extractHOGFeatures(currentImage, [x_center y_center], 'CellSize', [8 8]);
    if isempty(feats) == 0

        labels = [labels; currentLabelImage(y_center,x_center)];
        
        
        distancesFromjointPoints = zeros(1,14);
        
        for p =1:14
            distancesFromjointPoints(p) = sqrt( (x_center - jointPoints(p,1))^2  + (y_center - jointPoints(p,2))^2 );
        end
        
        result = predict(TrainedSVM, [feats distancesFromjointPoints feats2]);
        
        for y= 1:600
            for x = 1:400
                if (superPixels(y,x)) == j
                    outputImage(y,x) = result;
                end
            end
        end
    end
    
    labelmap = label2rgb(outputImage);
    %imwrite(RGB,images(i).name, 'jpg');
    image(labelmap);
end

