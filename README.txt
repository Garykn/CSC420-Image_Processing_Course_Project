This folder contains all the data and code for CSC420 Project 3: 
http://www.cs.utoronto.ca/~fidler/teaching/2017/CSC420.html

Explanation of the data:

- images/*.jpg    600 images
- labels/*_person.png   contains image labeling into person and background. If pixel has value 1, it belongs to the person class, otherwise it is background
- labels/*_clothes.png  contain image labeling for 6 clothing types and background. See labels.txt for the label information.

Function evaluateAccuracy evaluates accuracy of SVM prediction. Check the code to find out how to run it. 

TRAIN/TEST split:
We used 50% of the 600 images to train our classifiers. 50 images were used for testing purposes. 

Function:
