clear;
clc;
n = 10;
Message = [0.7 0.3];
Factors = [0.3 0.7; 0.5 0.5; 0.5 0.5; 0.3 0.7];
Coefficient = zeros(4,2);
for i=1:(n-1)
    row = 1;
    for j=1:2
        for k=1:2
            Coefficient(row,:) = Message(j)*Message(k);
            row = row + 1;
        end
    end
    Message = sum(Coefficient.*Factors);
    JointProbability(i) = Message(2);
end
JointProbability