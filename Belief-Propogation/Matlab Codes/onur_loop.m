Edges= [1,3;2,3];
Factors{1}=[0.3,0.7];
Factors{2}=[0.5,0.5];
Factors{3}=[0.2,0.8;0.1,0.9;0.3,0.7;0.4,0.6];
len = length(Edges(:,1));
num_of_nodes = max(Edges(:));

for i=1:num_of_nodes
    F(i) = -i;
end

FactorGraph = [0 0];
i = 1;
for j=1:len
    if any(Edges(j,i) == FactorGraph(:,2)) == 0
        FactorGraph = [FactorGraph;F(Edges(j,i)),Edges(j,i)];
    end
end
i = 2;
for j=1:len
    g2 = FactorGraph(:,2);
    if any(Edges(j,i) == FactorGraph(:,2)) == 0
        FactorGraph = [FactorGraph;F(Edges(j,i)),Edges(j,i);Edges(j,i-1),F(Edges(j,i))];
    else
        FactorGraph = [FactorGraph;Edges(j,i-1),F(Edges(j,i))];
    end
end

FactorGraph(1,:) = [];
MirrorGraph = rot90(FactorGraph,2);
FactorGraph = [FactorGraph;MirrorGraph];

for i=1:length(FactorGraph(:,1))
    if FactorGraph(i,1) > 0
        Messages{i} = ones(1,length(Factors{FactorGraph(i,1)}));
    else
        Messages{i} = ones(1,length(Factors{FactorGraph(i,2)}));
    end
end