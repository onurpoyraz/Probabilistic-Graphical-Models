clear;
clc;
a = 0.7;
b = 0.5;
c = 0.3;
n = 10;
G = zeros(n,n);
sample = 1000;

sum = zeros(n-1,1);
for index=1:sample
    for i=1:n
        for j=1:(n+1-i)
            G(i,j) = rand;
            if i == 1 && G(i,j) > 1-c
                G(i,j) = 1;
            elseif i == 1
                G(i,j) = 0;
            elseif G(i-1,j) == G(i-1,j+1) && G(i,j) > 1-a
                G(i,j) = 1;
            elseif G(i-1,j) ~= G(i-1,j+1) && G(i,j) > 1-b
                G(i,j) = 1;
            else
                G(i,j) = 0;
            end
        end
    end
    den = G(2:n,1);
    sum = sum + G(2:n,1);
    X(index) = sum(n-1) / index;
end
Probabilities = sum/sample
Range=[0 sample 0 1];
num_of_iter=1:sample;
figure(1)
plot(num_of_iter,X(num_of_iter));
axis(Range);