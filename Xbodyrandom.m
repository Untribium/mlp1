function[X]=Xbodyrandom(numofrun)


% This is the mainscript to create the Xmatrix out of the Braindata.
%
%%%%%%%%%%
% Input:    Int. The indexnumber of the Brian we want to work with.
% output:   index x numoffeatures matrix
%%%%%%%%%%
%
% functions documentation
% 1. Initialize a the empty Xmatrix and the targetagearray
% 2. runs all the given featureextractions and enters the featurevalues
%    into the Xmatrix.
% 3. plotes the resuluts versus the given age

index=278;


cd('/home/tobias/Dokumente/Studium/Machine learning/Matlab/data/set_train');
targetage = csvread('targets.csv');

numoffeatures=10; %change the number of features to the right number

 X=zeros(index,numoffeatures);
 
 numofbin=10;

 for randomrun=1:numofrun    %repetation of random examples
     cubesize=20;      %only strait inputs
     
     cubepos(1)=randi([15+cubesize/2 160-cubesize/2]);
     cubepos(2)=randi([16+cubesize/2 191-cubesize/2]);
     cubepos(3)=randi([5+cubesize/2 157-cubesize/2]);
     
    for indexcounter=1:index
    

        matrix=loadbrain(indexcounter);
        matrix=matrix(cubepos(1)-cubesize/2:cubepos(1)+cubesize/2,cubepos(2)-cubesize/2:cubepos(2)+cubesize/2,cubepos(3)-cubesize/2:cubepos(3)+cubesize/2);
        
       [X(indexcounter,1),X(indexcounter,2),X(indexcounter,3),X(indexcounter,4),X(indexcounter,5),X(indexcounter,6),X(indexcounter,7),X(indexcounter,8),X(indexcounter,9),X(indexcounter,10)]=featureextraction1(matrix,numofbin);
       
%        if indexcounter ==1
%            test=histogram(matrix,numofbin)
%        end
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

    featureplots(X,targetage,cubepos);
 end
 
end

