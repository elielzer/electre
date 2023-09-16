%%
% <latex>
% Decision Making - ELETRE \\
% Type P.$\alpha$ Problem.
% </latex>
% 

%%
% Problem dataset.
ProblemTable = 'ProblemTable.dat';
A = readtable(ProblemTable);
save('ProblemTable.mat','A')
load ProblemTable
%%
% Assessment dataset.
EvalTable = 'EvalTable.dat';
G = readtable(EvalTable);
save('EvalTable.mat','G') 
load EvalTable

%%
% Thresholds values.
Thresholds = 'thresholds.dat';
T = readtable(Thresholds);

%%
% Normalization of weights

table
%% 
% Concordance matrix

% normalize weight values
fileID = fopen('EvalTable.dat');
C = textscan(fileID,'%s %f %s %f');
fclose(fileID);
wsum=0;

for id = 1: size(G,1)
    wsum= wsum + G.Wheight(id);
end
disp(  wsum);
disp(G)


