helpfunction[featureval1,featureval2,featureval3,featureval4,featureval5,featureval6,featureval7,featureval8,featureval9,featureval10]=featureextraction1(matrix,numofbin)


% This function extracts a information out of the 4D-matrix (voxel box).$
% Histogram
%
%%%%%%%%%%
% Input:    176x208x176xint16. The 4D brain Matrix.
            
% output:   1 int. skalar value
%%%%%%%%%%
%
% Definition of the extractionmethode:
%
%example


hist=histogram(matrix,numofbin);
featureval1=hist.Values(1*round(numofbin/10));
featureval2=hist.Values(2*round(numofbin/10));
featureval3=hist.Values(3*round(numofbin/10));
featureval4=hist.Values(4*round(numofbin/10));
featureval5=hist.Values(5*round(numofbin/10));
featureval6=hist.Values(6*round(numofbin/10));
featureval7=hist.Values(7*round(numofbin/10));
featureval8=hist.Values(8*round(numofbin/10));
featureval9=hist.Values(9*round(numofbin/10));
featureval10=hist.Values(numofbin);
end
