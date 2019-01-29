clear;
clc;
a = 0.7;
b = 0.5;
c = 0.3;
n = 10;
G = zeros(n,n);
sample = 1000;

Cs = 1-a;
alfa = log(b*(1-a)/(a*(1-b)));
beta = log((1-b)/(1-a));
gama = log(a/(1-a));
sigma = log(c/(1-c));

sum = zeros(n-1,1);
X = zeros(sample,1);
for num_of_iter=1:sample
    for i=1:n
        for j=1:(n-i+1)
            G(i,j) = rand;
            if i==1
                Ps = [Cs Cs*exp(sigma*1)];
            else
                y = G(i-1,j);
                z = G(i-1,j+1);
                x = 1;
                Ps = [Cs*exp(beta*(y-z)^2) Cs*exp(alfa*x*(y-z)^2+beta*(y-z)^2+gama*x)];
            end
            PsX = Ps(2)/(Ps(1)+Ps(2));
            if G(i,j) < PsX
                G(i,j) = 1;
            else
                G(i,j) = 0;
            end
        end
    end
    sum = sum + G(2:n,1);
    X(num_of_iter) = sum(n-1)/num_of_iter;   
end
Probabilities = sum/sample
Range=[0 sample 0 1];
num_of_iter=1:sample;
figure(1)
plot(num_of_iter,X(num_of_iter));
axis(Range);