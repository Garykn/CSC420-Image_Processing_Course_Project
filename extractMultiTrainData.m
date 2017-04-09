function [labels, features] = extractMultiTrainData(truths)
%EXTRACT Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('./images'));
addpath(genpath('./labels'));
images = dir('images/*.jpg');
labelImages = dir('labels/*clothes.png');
labels = {};
features = [];

for i=1:250
    currentImage = imread(images(i).name);
    currentLabelImage = imread(labelImages(i).name);
    [superPixels,NumLabels] = superpixels(currentImage,200);
    [rowsize, columnsize] = size(superPixels);
    superPixelIndices = label2idx(superPixels);
    superPixelCount = length(superPixelIndices);
    
    for j=1:superPixelCount
        %finding center of super pixel
        x_left = min(mod(superPixelIndices{j}, rowsize) );
        x_right = max(mod(superPixelIndices{j}, rowsize) );
        
        y_min =  min(superPixelIndices{j}/rowsize) + 1;
        y_max =  max(superPixelIndices{j}/rowsize) + 1;

        y_center = round(x_left + (x_right - x_left)/2);
        x_center = round(y_min + (y_max - y_min)/2);

        %get the joint points in the image from truths corresponding structure
		%this returns a 14x2 array of points
        jointPoints = truths(i).pose.point;
      
        if x_center-12 <= 0 || x_center+12 > 400 || y_center-12 <= 0 || y_center+12 > 600
             continue;
        end
        
   
        feats2 = extractLBPFeatures(rgb2gray(currentImage(y_center-10: y_center+10, x_center-10: x_center+10, 1:3)));
        [feats, validPoints] = extractHOGFeatures(currentImage, [x_center y_center], 'CellSize', [8 8]);
        
         if isempty(feats) == 0
            %find label/category of center point
            %label = currentLabel);
            text(x_center,y_center,int2str(currentLabelImage(y_center,x_center)));
			%add label to our labels cell array
            labels = [labels; currentLabelImage(y_center,x_center)];

			%jointPoints = truths(i).pose.point;
			
			%array to hold euclidean distances form joint points in image to cener of superpixel
			distancesFromjointPoints = zeros(1,14);
			
			for p =1:14
				distancesFromjointPoints(p) = sqrt( (x_center - jointPoints(p,1))^2  + (y_center - jointPoints(p,2))^2 );
            end
            
            %Now we append our pose info to our HOG 1x36 feature vector
            %4 times to get a 1x92 vector
            feats = [feats distancesFromjointPoints feats2];
            
            %add to features matrix
            features = [features; feats];
            
        end
        
    end
end

