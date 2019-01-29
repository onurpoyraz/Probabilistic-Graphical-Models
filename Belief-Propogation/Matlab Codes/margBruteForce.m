function margBruteForce(Edges,Factors)

len = length(Edges(:,1));
num_of_nodes = max(Edges(:)); 

for i=1:num_of_nodes
    if any(Edges(:,2)==i) == 0
        margs{i} = Factors{i}; 
    else
        fact = Factors{i};
        [row,column] = size(fact);
        coef = 1;
        for j = 1:len
            if i == Edges(j,2)
                marg = margs{Edges(j,1)}';
                marg_len = length(marg);
                marg_matrix = [];
                for k = 1:marg_len
                    marg_matrix = [marg_matrix;repmat(marg(k),coef,1)];
                end
                fact = fact.*repmat(marg_matrix,row/length(marg_matrix),column);
                coef = coef*marg_len;
            end
        end
        sum = 0;
        for l = 1:row
            sum = sum + fact(l,:);
        end
        margs{i} = sum; 
    end
end

for i=1:num_of_nodes
    margs{i}
end