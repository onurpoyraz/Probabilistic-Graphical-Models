function JointProb = JointProbability(Edges,Factors,x)

len = length(Edges(:,1));
num_of_nodes = max(Edges(:));

for i=1:num_of_nodes
    if any(Edges(:,2)==i) == 0
        JointProb(i) = Factors{i}(x(i)+1);
    else
        Parents = [];
        length_parents_factor = [];
        for j=1:len
            if i == Edges(j,2);
                Parents = [Parents Edges(j,1)];
                length_parents_factor =  [length_parents_factor length(Factors{Edges(j,1)}(1,:))];
            end
        end
        num_of_parents = length(Parents);
        for j=1:num_of_parents
            order = length(Factors{i}(:,1))/length_parents_factor(num_of_parents+1-j);
            Factors{i} = Factors{i}(order*x(Parents(num_of_parents+1-j))+1:order*(x(Parents(num_of_parents+1-j))+1),:);
        end
        JointProb(i) = Factors{i}(x(i)+1);
        for k=1:num_of_parents
            JointProb(i) = JointProb(i)*JointProb(Parents(k));
        end
    end
end 