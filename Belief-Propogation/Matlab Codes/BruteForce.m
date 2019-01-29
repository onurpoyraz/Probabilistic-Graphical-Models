%function margBruteForce(edges,factors)
edges= [1,3;2,3];
factors = cell(3,1);
factors{1}=[0.3,0.7];
factors{2}=[0.5,0.5];
factors{3}=[0.2,0.8;0.1,0.9;0.3,0.7;0.4,0.6];
num_of_variables = max(edges(:)); 
marginals = cell(num_of_variables,1);

for i=1:num_of_variables
    if any(edges(:,2)==i) == 0
        marginals{i} = factors{i}; 
    else
        factor = factors{i}; 
        [rows,columns] = size(factor); 
        for j=1:length(edges(:,1))
            if i==edges(j,2)
                marg_arr = [];
                g1 = edges(j,1);
                %[rows,columns] = size(factors{g1}); 
                marginal = marginals{g1}; 
                marginal_length = length(marginal); 
                for k=1:(rows/marginal_length)
                    mult_res = factor((k-1)*marginal_length +1:k*marginal_length,:).*repmat(marginal',1,columns);
                    mult_res = sum(mult_res); 
                    marg_arr = [marg_arr;mult_res];
                end
                factor = marg_arr; 
                [rows,columns] = size(factor);
            end
        end
        marginals{i} = factor; 
    end
end
%print marginals
for i=1:num_of_variables
    marginals{i} 
end
%end
