This folder contains all the data, code, and resource references for CSC420 Project 3: 
http://www.cs.utoronto.ca/~fidler/teaching/2017/CSC420.html


Explanation of the data:

- images/*.jpg    600 images
- labels/*_person.png   contain binary image label maps where each pixel is either 0 if it belongs to the bakcground of the imge 
  or 1 if it belongs to the perosn in the image. 
- labels/*_clothes.png  contain multi-class label maps where each pixel takes on one of the 7 values: 0,1,2,3,4,5,6 
  depending on its category in {“background”, “skin”, “hair”, “t-shirt”, “shoes”, “pants”, “dress”}.

-.mat files that contain trained SVMS, train data and test data for the SVMs. 
-The truths.mat file cotainst the truths struct array from fashionista-v0.2.1.tgz. Each struct in this array contains pose    
 information for one of our train images. 


TRAIN/TEST split:
We used 50% of the 600 images and their correspnding label maps to train our classifiers. 
50 images were used for testing purposes.

The functions below are self explanatory. make sure you run the startup.m file first to add directory paths to your
matlab runtime environment before you run these function. 
Function:

[outputImage ] = personBackgroundDetector(truths)

[labels, features] = extractBinaryTrainData(truths)

[labels, features] = extractMultiTrainData(truths)

labelmap = labelimagebinary(TrainedSVM, img)

labelmap = labelimagemulti(TrainedSVM, img)

totalAccuracy = evaluateAccuracy(results, testlabels)


To use the functions in the libsvm library "windows", make sure you're on a Windows platform and that you run the startup.m script first. 


Sources of data (images + label maps + truths.mat(contains joint point information for the imagees)+ libsvm 3.2.2):

Sources used to obtain data: 
http://vision.is.tohoku.ac.jp/~kyamagu/research/clothing_parsing/

Sources used for code and experimental work:
http://www.csie.ntu.edu.tw/~cjlin/libsvm/