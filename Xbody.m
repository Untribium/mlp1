function[X]=Xbody(index)


% This is the mainscript to create the Xmatrix out of the Braindata.
%
%%%%%%%%%%
% Input:    Int. The indexnumber of the Brian we want to work with.
% output:   index x numoffeatures matrix
%%%%%%%%%%
%
%functions documentation
% 1. Initialize a the empty Xmatrix and the targetagearray
% 2. runs all the given featureextractions and enters the featurevalues
%    into the Xmatrix.
% 3. plotes the resuluts versus the given age

%TODO load targetage into a
cd('/home/tobias/Dokumente/Studium/Machine learning/Matlab/data/set_train');
targetage = csvread('targets.csv');

numoffeatures=1; %change the number of features to the right number

 X=zeros(index,numoffeatures);

    for indexcouter=1:index
    

        matrix=loadbrain(index);

        featureval1=featureextraction1(matrix);
        X(indexcouter,1)=featureval1;
% 
%         (featurval2)=featureextraction2(matrix);
%         X(indexcouter,2)=featureval2;
% 
%         (featurval3)=featureextraction3(matrix);
%         X(indexcouter,3)=featureval3;
% 
%         (featurval4)=featureextraction4(matrix);
%         X(indexcouter,4)=featureval4;
    end

    %featureplots(X,targetage);
end
