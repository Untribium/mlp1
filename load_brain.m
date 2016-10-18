% load specific brain data from specified data set
% input: data set and index of the brain data to be loaded
% output: 176x208x176 matrix integer matrix
function[matrix] = load_brain(set, index)

    % construct path, data must be placed here!
    path = strcat('./data/set_', set, '/');
    % construct file name
    file = strcat(set, '_', num2str(index), '.nii');
    
    % load brain using nifty libs
    brain = load_nii(strcat(path, file));
    %extract matrix from brain struct
    matrix = brain.img;
    
end