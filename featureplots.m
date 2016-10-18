function []=featureplots(X,targetage,cubepos)


% This function plots the featurevalues verses the known age.
% It show one plot for every featurextraction.
%
%
%%%%%%%%%%
% Input:    278x1 vector of the known ages,
%           index  x numoffeatures Xmatrix containig the featurevalues
%            !!!!  numoffeatures must be positive and between 0 and 100
% output:   one plot for each featureextraction
%%%%%%%%%%
%
%  Functions documentation:
% 1. define the subplotsize in dependants of the numoffeature
% 2. creates the plots



[numofexamples,numoffeature]=size(X);
subplotwindowx=ceil(sqrt(numoffeature));
subplotwindowy=ceil(sqrt(numoffeature));
     
 s1= 'The cubecenter vector[x y z] is ';
 s2=num2str(cubepos);
 figname = strcat(s1,s2);


fig=figure;
fig.Name= figname;
for featurecounter=1:numoffeature
        

         subplot(subplotwindowx,subplotwindowy,featurecounter)   
         plot(targetage(1:numofexamples),X(:,featurecounter),'.b')
         %axis([0 100 0 100]);    % TODO change the axislimits of the featureval-axis(the second paire)
         title(['Feature Number ',num2str(featurecounter)]);
         xlabel('age');
         ylabel('featurevalue');
         %axis equal
end
