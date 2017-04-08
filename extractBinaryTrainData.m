function [labels, features] = extractBinaryTrainData(truths)
%EXTRACT Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('./images'));
addpath(genpath('./labels'));
images = dir('images/*.jpg');
labelImages = dir('labels/*person.png');

%[rowsize, columnsize] = size(superPixels);
%superPixelCount = length(superPixelIndices);


labels = [];
features = [];

for i=301:350
    
    currentImage = imread(images(i).name);
    currentLabelImage = imread(labelImages(i).name);
    [superPixels, NumLabels] = superpixels(currentImage,150);
    [rowsize, columnsize] = size(superPixels);
    
	%BW = boundarymask(superPixels);
    superPixelIndices = label2idx(superPixels);
    superPixelCount = length(superPixelIndices);

    %imshow(imoverlay(currentImage,BW,'cyan'),'InitialMagnification',67);
    %hold on;
	
    %image(imaget);
	
    for j=1:superPixelCount
		%compute center of superpixel
        x_left = min(mod(superPixelIndices{j}, rowsize) );
        x_right = max(mod(superPixelIndices{j}, rowsize) );
        
        y_min =  min(superPixelIndices{j}/rowsize) + 1;
        y_max =  max(superPixelIndices{j}/rowsize) + 1;

        x_center = floor(x_left + (x_right - x_left)/2);
        y_center = floor(y_min + (y_max - y_min)/2);
        
		%plot center of superpixel on image
       % plot(y_center,x_center,'r.','MarkerSize',10);
        
        %move on to the next superpixel if current supepixel isn't fit for
        %feature extraction
        if x_center-11 <= 0 || x_center+12 > 600 || y_center-12 <= 0 || y_center+11 > 400
             continue;
        end
  
		%extract HOG feature around the point using the surrounding 24x24 pixel grid - shape informatin
		%return 1x900 data vector
        %feats1 = extractHOGFeatures(currentImage(x_center-11: x_center+12, y_center-12: y_center+11, 1:3));
		
		%extract LPB features around the point using the surrounding 24x24 pixel grid - texture information
		%return 1x59 data vector
		feats2 = extractLBPFeatures(rgb2gray(currentImage(x_center-11: x_center+12, y_center-12: y_center+11, 1:3)));
       
        if isempty(feats2) == 0
            %find label/category of center point
            
			%text(y_center,x_center,int2str(currentLabelImage(x_center,y_center)));
			
			%add label to our labels cell array
   
            labels = [labels; currentLabelImage(x_center,y_center)];
			%get the joint points in the image from truths corresponding structure
			%this returns a 14x2 array of
			
			%jointPoints = truths(i).pose.point;
			%array to hold euclidean distances form joint points in image to cener of superpixel
			%distancesFromjointPoints = zeros(1,14);
			
			%for p =1:14
			%	distancesFromjointPoints(p) = sqrt( (x_center - jointPoints(p,1))^2  + (y_center - jointPoints(p,2))^2 );
            %end
          
            %add to features matrix
            features = [features; feats2];
            
        end
    end
end

