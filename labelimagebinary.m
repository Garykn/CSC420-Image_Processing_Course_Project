function labelmap = labelimagebinary(TrainedSVM, img)

%we'll be using the trained SVM using appraoch #1 in the report, due to it having the hgihest prediction accuracy.

%segment the image into superpixels - 150 of them at most
[superPixels, NumLabels] = superpixels(img, 150);

[rowsize, columnsize] = size(superPixels);

superPixelIndices = label2idx(superPixels);
superPixelCount = length(superPixelIndices);


%variables to hold labels of superpixels and SVM data for superpixels
splabels = [];
features = [];

    for j=1:superPixelCount
	
		%compute center of superpixel
        x_left = min(mod(superPixelIndices{j}, rowsize) );
        x_right = max(mod(superPixelIndices{j}, rowsize) );
        
        y_min =  min(superPixelIndices{j}/rowsize) + 1;
        y_max =  max(superPixelIndices{j}/rowsize) + 1;

        x_center = floor(x_left + (x_right - x_left)/2);
        y_center = floor(y_min + (y_max - y_min)/2);
        
        
        %If not able to extract a 24x24 region around superpixel, then it's too close to edge and we can assume
		%the superpixel belong to background
        if x_center-11 <= 0 || x_center+12 > 600 || y_center-12 <= 0 || y_center+11 > 400
			%label 0 for background
			splabels = [splabels 0];
			
			%move on to the next superpixel
            continue;
        end
  
  
		%extract HOG feature around the center using the surrounding 24x24 pixel grid - shape informatin
		%reutrn a 144x1 feature vector
        feature = extractLBPFeatures(rgb2gray(img(x_center-11: x_center+12, y_center-12: y_center+11, 1:3)));
       
        if isempty(feature) == 0
			
			label = predict(TrainedSVM, feature)
            %[label, accuracy, decs] = svmpredict(double(1), double(feature), TrainedSVM);
			splabels = [splabels label];
		else
			%feature extraction failed -  assume superpixel belongs to background
            splabels = [splabels 0];
        end
    end
	
	%at this point, we have labeled each superpixel in our image
	%Next, for each pixel in the superpixel map, we assign to it its label 
	labelmap = superPixels;
	
	
	for x = 1:600
		for y = 1:400
			labelmap(x,y) = splabels(labelmap(x,y));
		end
	end


end