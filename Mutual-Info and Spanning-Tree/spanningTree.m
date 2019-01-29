function spanningTree
MI = mutualInfo();
arrayMI = zeros(45,3);
count = 0;
for i=1:9
    for j=(i+1):10
        count = count + 1;
        arrayMI(count,1) = MI(j,i);
        arrayMI(count,2) = i;
        arrayMI(count,3) = j;
    end
end

sortedarrayMI = -1*sortrows(-arrayMI,1); %sorting mutual info values

E = zeros(18,2); %tree with connected pairs
i = 1;
while i<=9
    checkedloop = 0;
    for j=1:18
        if E(j,1)==sortedarrayMI(i,2)
            %check if there is loop, by using depth first search
            if depthFirstSearch(E,E(j,2),sortedarrayMI(i,3),0) == 1
                checkedloop = 1;
                sortedarrayMI(i,:) = [];
                i = i - 1;
                break
            end
        end
    end
    %if no loop, add highest weighted edge to the tree
    if checkedloop == 0
        E(i,1) = sortedarrayMI(i,2);
        E(i,2) = sortedarrayMI(i,3);
        E(19-i,1) = sortedarrayMI(i,3);
        E(19-i,2) = sortedarrayMI(i,2);
    end
    i = i+1;
end

    function sit = depthFirstSearch(A,x,y,count)
        count = count + 1; %to prevent unnecessary searches
        sit = 0;
        for t=1:length(A(:,1))
            if A(t,1) == x
                if A(t,2) == y
                    sit = 1;
                    break
                else
                    if count>5
                        break
                    else
                        if depthFirstSearch(A,A(t,2),y,count) == 1
                            sit = 1;
                            break;
                        end
                    end
                end
            end
        end
    end

for i=1:9
    E(19-i,:) = [];
end

E

end