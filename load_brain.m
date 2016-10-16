
function[matrix] = load_brain(set, index)

% This function loads the Braindata out of the directory and converts it into the 4D-matrix
% TODO change the testrun and trainrun argument
%
%%%%%%%%%%
% Input:    Int. The indexnumber of the Brian we want to work with.
% output:   176x208x176xint16. The 4D brain Matrix.
%%%%%%%%%%
%
% functions documentation
% 1. opening the directory
% 2. constructing a string containing the wanted filename
% 3. loading the 4D matrix

path = strcat('./data/set_', set, '/');
file = strcat(set, '_', num2str(index), '.nii');

brain = load_nii(strcat(path, file));
matrix = brain.img;

clear s1 s2 s3 filename;