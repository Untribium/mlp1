
function[matrix]=loadbrain(index)


% This function loads the Braindata out of the directory and converts it into the 4D-matrix
% TODO change the testrun and trainrun argument
%
%%%%%%%%%%
% Input:    Int. The indexnumber of the Brian we want to work with.
% output:   176x208x176xint16. The 4D brain Matrix.
%%%%%%%%%%
%
%functions documentation
% 1. opening the directory
% 2. constructing a string containing the wanted filename
% 3. loading the 4D matrix

 cd('/home/tobias/Dokumente/Studium/Machine learning/Matlab/data/set_train');
   % cd('/home/tobias/Dokumente/Studium/Machine learning/Matlab/data/set_test'); change for testrun!!!

 s1='train_';
   % s1='test_'; change for testrun!!!
 s2=num2str(index);
 s3='.nii';
 filename = strcat(s1,s2,s3);

brain=load_nii(filename);
matrix=brain.img;

clear s1 s2 s3 filename;