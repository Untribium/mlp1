function create_submission(pred, suite_name)
    if(nargin < 2)
        error('Not enough input args!');
    end
    path = ['./extractors/', suite_name, '/prediction.csv'];
    fid = fopen(path, 'w');
    fprintf(fid, 'ID,Prediction\n');
    fclose(fid);
    
    pred = [(1:length(pred))', pred];
    
    dlmwrite(path, pred, '-append');
end
