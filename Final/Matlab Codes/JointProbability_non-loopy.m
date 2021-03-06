clear;
clc;
Edges = [1,3;2,3;2,4;3,5];
Factors{1} = [0.6,0.4];
Factors{2} = [0.7,0.3];
Factors{3} = [0.3 0.4 0.3; 0.05 0.25 0.7; 0.9 0.08 0.02; 0.5 0.3 0.2];
Factors{4} = [0.95,0.05;0.2,0.8];
Factors{5} = [0.1,0.9;0.4,0.6;0.99,0.01];
x = [0,1,2,0,1];
JointProb = JointProbability(Edges,Factors,x)