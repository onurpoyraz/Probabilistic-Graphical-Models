clear;
clc;
data = load('diningData.mat');
DiningData = data.diningData;

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
sorted_mutual_info = flip(sorted_mutual_info,1)
