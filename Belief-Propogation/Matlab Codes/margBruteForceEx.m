clear;
clc;
Edges = [1,3;2,3];
Factors{1} = [0.3,0.7];
Factors{2} = [0.7,0.3];
Factors{3} = [0.2,0.8;0.1,0.9;0.3,0.7;0.4,0.6];

margBruteForce(Edges,Factors)