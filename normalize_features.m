function [X,Xt,nf] = normalize_features(X,Xt, threshold)

    nf = zeros(size(X,2),2);
    
    for i=size(X,2):-1:1
        nf(i,1) = min(X(:,i));
        
        X(:,i) = X(:,i)-nf(i,1);
        
        nf(i,2) = max(X(:,i));
        
        if(nf(i,2) > 0)
            X(:,i) = X(:,i)/nf(i,2);
        else
            Xt(:,i) = [];
            X(:,i) = [];
            nf(i,:) = [];
        end
    end
    
    for i=size(Xt,2):-1:1
        Xt(:,i) = Xt(:,i)-nf(i,1);
        Xt(:,i) = Xt(:,i)/nf(i,2);
        
        if(max(Xt(:,i)) > threshold || max(Xt(:,i)) < 1/threshold)
            X(:,i) = [];
            Xt(:,i) = [];
            nf(i,:) = [];
        end
    end
end