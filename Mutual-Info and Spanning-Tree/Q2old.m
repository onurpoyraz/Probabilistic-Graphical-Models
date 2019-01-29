clear;
clc;
data = load('diningData.mat');
DiningData = data.diningData;
category = load('categoryNames.mat');
CategoryNames = category.categoryNames;

mutual_info = zeros(45,3);
count = 0;
for i=1:9
    for j=(i+1):10
        count = count + 1;
        Ione = 0;
        Izero = 0;
        Jone = 0;
        Jzero = 0;
        IJoneone = 0;
        IJonezero = 0;
        IJzeroone = 0;
        IJzerozero = 0;
        for t=1:length(DiningData(1,:))
            if DiningData(i,t) == 0
                Izero = Izero + 1;
            else
                Ione = Ione + 1;
            end
            
            if DiningData(j,t) == 0
                Jzero = Jzero + 1;
            else
                Jone = Jone + 1;
            end
            
            if DiningData(i,t)==0 && DiningData(j,t)==0
                IJzerozero = IJzerozero + 1;
            elseif DiningData(i,t)==1 && DiningData(j,t)==0
                IJonezero = IJonezero + 1;
            elseif DiningData(i,t)==0 && DiningData(j,t)==1
                IJzeroone = IJzeroone + 1;
            elseif DiningData(i,t)==1 && DiningData(j,t)==1
                IJoneone = IJoneone + 1;
            end
        end
        PIone = Ione/2784;
        PIzero = Izero/2784;
        PJone = Jone/2784;
        PJzero = Jzero/2784;
        PIJoneone = IJoneone/2784;
        PIJonezero = IJonezero/2784;
        PIJzeroone = IJzeroone/2784;
        PIJzerozero = IJzerozero/2784;
        mutual_value = PIJoneone*log(PIJoneone/(PIone*PJone)) + PIJonezero*log(PIJonezero/(PIone*PJzero)) + PIJzeroone*log(PIJzeroone/(PIzero*PJone)) + PIJzerozero*log(PIJzerozero/(PIzero*PJzero));
        mutual_info(count,1) = mutual_value;
        mutual_info(count,2) = i;
        mutual_info(count,3) = j;
    end
end
sorted_mutual_info = sortrows(mutual_info,1);
sorted_mutual_info = flip(sorted_mutual_info,1);


tree(1,1:2) = sorted_mutual_info(1,2:3);
container(1,1) = sorted_mutual_info(1,2);
container(1,2) = sorted_mutual_info(1,3);
for i=2:45
    control_bit = 0;
    first = 1;
    second = 1;
    check1 = zeros(1,length(container(:,1)));
    check2 = zeros(1,length(container(:,1)));
    for j=1:length(container(:,1))
        for k=1:length(container(1,:))
            if sorted_mutual_info(i,2) == container(j,k)
                check1(j) = 1;
                first = j;
            end
            if sorted_mutual_info(i,3) == container(j,k)
                check2(j) = 1;
                second = j;
            end
        end
        if check1(j) == 1 && check2(j) == 1
            control_bit = 1;
        end
    end
    
    if control_bit == 0
        tree(length(tree(:,1))+1,1:2) = sorted_mutual_info(i,2:3);
        for j=1:length(check1)
            if norm(check1,1) ~= 0 && norm(check2,1) ~= 0
                container(first,length(container(1,:))+1:2*length(container(1,:))) = container(second,:);
            elseif check1(j) == 1
                container(j,length(container(1,:))+1) = sorted_mutual_info(i,3);
            elseif check2(j) == 1
                container(j,length(container(1,:))+1) = sorted_mutual_info(i,2);
            end
        end
        if norm(check1,1) == 0 && norm(check2,1) == 0
            container(length(container(:,1))+1,1:2) = sorted_mutual_info(i,2:3);
        end
    end 
end
tree
