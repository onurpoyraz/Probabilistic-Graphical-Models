%function loopyBP(edges,factors)
%edges=[1,3;2,3;2,4;3,5];
edges= [1,3;2,3];
factors = cell(3,1);
factors{1}=[0.3,0.7];
factors{2}=[0.5,0.5];
factors{3}=[0.2,0.8;0.1,0.9;0.3,0.7;0.4,0.6];
%creating factor nodes
f = zeros(max(edges(:)),1);
for i=1:length(f)
    f(i) = -i; %negative numbers to detect factor nodes
end

%creating factor graph
graph = [0 0];
for i=1:2
    for j=1:length(edges(:,1))
        if i==1
            g2 = graph(:,2);
            if any(edges(j,i)==g2)==0
                added = [f(edges(j,i)),edges(j,i)];
                graph = [graph;added];
            end
        else
            g2 = graph(:,2);
            if any(edges(j,i)==g2)==0
                added = [f(edges(j,i)),edges(j,i)];
                graph = [graph;added];
                added = [edges(j,i-1),f(edges(j,i))];
                graph = [graph;added];
            else
                added = [edges(j,i-1),f(edges(j,i))];
                graph = [graph;added];
            end
        end
    end
end

graph(1,:) = [];
mirror_graph = flipud(fliplr(graph));
graph = vertcat(graph,mirror_graph); %this now contains cliques
messages = cell(length(graph(:,1)),1);

%initialize messages
for i=1:length(messages)
    if graph(i,1) > 0
        messages{i} = ones(1,length(factors{graph(i,1)}));
    else
        messages{i} = ones(1,length(factors{graph(i,2)}));
    end
end

%updating
for i=1:length(messages)
    g1 = graph(i,1);
    g2 = graph(i,2);
    %message from factor to variable
    if g1<0
        count = 0;
        neighbors = []; %neighbours of the factor
        neighbors_idx = [];
        for j=1:length(messages)
            if graph(j,2) == g1
                count = count + 1;
                neighbors = [neighbors graph(j,1)];
                neighbors_idx = [neighbors_idx j];
            end
        end
        %if factor has no other neighbor
        if count==1
            messages{i} = factors{g2};
        %if factor has other neighbors
        else
            for j=1:length(messages)
                if graph(j,1) == g1
                    factor_num = graph(j,2);
                    break
                end
            end
            [neighbors,sort_order] = sort(neighbors);
            neighbors_required_idx = neighbors_idx(:,sort_order);
            id = find(neighbors==g2);
            idx = neighbors_required_idx(id);
            neighbors_required = neighbors(find(neighbors~=g2));
            neighbors_required_idx(id) = [];
            shape_of_g2 = length(messages{idx});
            ar = [];
            if length(neighbors)==2
                idx_g2 = find(neighbors==g2);
                for j=1:length(messages{neighbors_required(1)})
                    if idx_g2==1
                        if size(factors{factor_num}(:,j),1)>1
                            reshaped_factor = (factors{factor_num}(:,j))';
                        else
                            reshaped_factor = (factors{factor_num}(:,j));
                        end
                        %reshaped_factor = reshape(factors{factor_num}(:,j),[1,shape_of_g2]);
                        ar = [ar;reshaped_factor*messages{neighbors_required_idx(1)}(j)];
                    else
                        if size(factors{factor_num}(j,:),1)>1
                            reshaped_factor = (factors{factor_num}(j,:))';
                        else
                            reshaped_factor = (factors{factor_num}(j,:));
                        end
                        %reshaped_factor = reshape(factors{factor_num}(j,:),[1,shape_of_g2]);
                        ar = [ar;reshaped_factor*messages{neighbors_required_idx(1)}(j)];
                    end
                end
                messages{i} = sum(ar);
            end
            if length(neighbors)==3
                idx_g2 = find(neighbors==g2);
                for j=1:length(messages{neighbors_required(1)})
                    for k=1:length(messages{neighbors_required(2)})
                        if idx_g2==1
                            if size(factors{factor_num}(:,j,k),1)>1
                                reshaped_factor = (factors{factor_num}(:,j,k))';
                            else
                                reshaped_factor = (factors{factor_num}(:,j,k));
                            end
                            %reshaped_factor = reshape(factors{factor_num}(:,j,k),[1,shape_of_g2]);
                            ar = [ar;reshaped_factor*messages{neighbors_required_idx(1)}(j)*messages{neighbors_required_idx(2)}(k)];
                        elseif idx_g2==2
                            if size(factors{factor_num}(j,:,k),1)>1
                                reshaped_factor = (factors{factor_num}(j,:,k))';
                            else
                                reshaped_factor = (factors{factor_num}(j,:,k));
                            end
                            %reshaped_factor = reshape(factors{factor_num}(j,:,k),[1,shape_of_g2]);
                            ar = [ar;reshaped_factor*messages{neighbors_required_idx(1)}(j)*messages{neighbors_required_idx(2)}(k)];
                        else
                            if size(factors{factor_num}(j,k,:),1)>1
                                reshaped_factor = (factors{factor_num}(j,k,:))';
                            else
                                reshaped_factor = (factors{factor_num}(j,k,:));
                            end
                            %reshaped_factor = reshape(factors{factor_num}(j,k,:),[1,shape_of_g2]);
                            ar = [ar;reshaped_factor*messages{neighbors_required_idx(1)}(j)*messages{neighbors_required_idx(2)}(k)];
                        end
                    end
                end
                messages{i} = sum(ar);
            end
            %factors{2}(1,:)
            %factors{2}(:,:,1)     
        end
    %message from variable to factor
    else
        count = 0;
        neighbors = []; %neighbours of the variable
        neighbors_idx = []; %places of neighbours of the variable in the graph
        for j=1:length(messages)
            if graph(j,2) == g1
                count = count + 1;
                neighbors = [neighbors graph(j,1)];
                neighbors_idx = [neighbors_idx j];
            end
        end
        %if factor has no other neighbor
        if count==1
            messages{i} = ones(1,length(messages{i}));
        %if factor has other neighbors
        else
            [neighbors,sort_order] = sort(neighbors);
            neighbors_required_idx = neighbors_idx(:,sort_order);
            id = find(neighbors==g2);
            idx = neighbors_required_idx(id);
            ar = ones(1,length(messages{idx}));
            neighbors_required = neighbors(find(neighbors~=g2));
            neighbors_required_idx(id) = [];
            for j=1:length(neighbors_required)
                %messages{neighbors_required_idx(j)} = size(reshape(messages{neighbors_required_idx(j)},size(ar)));
                messages{neighbors_required_idx(j)} = size(reshape(messages{neighbors_required_idx(j)},2,2));
                ar = ar.*messages{neighbors_required_idx(j)};
            end
            messages{i} = ar;
        end
    end
end

%computing beliefs
num_of_variables = max(edges(:));
beliefs = cell(num_of_variables,1);

%initialize beliefs
for i=1:num_of_variables
    for j=1:length(messages)
        if graph(j,2) == i
            beliefs{i} = ones(1,length(factors{i}));
            break
        end
    end
end

%find beliefs
for i=1:num_of_variables
    for j=1:length(messages)
        if graph(j,2) == i
            beliefs{i} = beliefs{i}.*messages{j};
        end
    end
    beliefs{i} = beliefs{i}/sum(beliefs{i});
end

beliefs{2}

%end