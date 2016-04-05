function [p]=normalize(p, inds)
    for i=inds
        constant=sum(sum(p{i}));
        p{i}=p{i}/constant;
    end
end