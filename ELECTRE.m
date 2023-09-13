%%
% <latex>
% Decision Making - ELETRE \\
% Type P.$\alpha$ Problem.
% </latex>
% 

%%
% Problem dataset.
ProblemTable = 'ProblemTable.dat';
delimiterIn = ' ';
headerlinesIn = 1;
A = importdata(ProblemTable,delimiterIn,headerlinesIn);

save('ProblemTable.mat','A')
load ProblemTable
%%
% Assessment dataset.
EvalTable = 'EvalTable.dat';
delimiterIn = ' ';
headerlinesIn = 1;
G = importdata(EvalTable,delimiterIn,headerlinesIn);
save('EvalTable.mat','G') 
load EvalTable
%%
% Thresholds values.
Thresholds = 'thresholds.dat';
delimiterIn = ' ';
headerlinesIn = 1;
T = importdata(Thresholds,delimiterIn,headerlinesIn);

%% 