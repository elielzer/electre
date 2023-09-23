%%
% <latex>
% Decision Making - ELECTRE \\
% Type P.$\alpha$ Problem.
% </latex>
% 

%%
% Problem dataset.
ProblemTable = 'ProblemTable.dat';
AG = readtable(ProblemTable);
sizeAG = size(AG) ;
disp(sizeAG(2))
save('ProblemTable.mat','AG')
load ProblemTable
%%
% Assessment dataset.
EvalTable = 'EvalTable.dat';
W = readtable(EvalTable);
save('EvalTable.mat','W') 
load EvalTable

%%
% Thresholds values.
Thresholds = 'thresholds.dat';
T = readtable(Thresholds);

%%
% Normalization of weights
wsum=0;

for id = 1: size(W,1)
    wsum= wsum + W.Weight(id);
end

% Redo weights matrix with normalized weight values.
WW=W;
WW.Weight=(1/wsum)*W.Weight;
sizeWW = size(WW);
disp(WW)

%%
% Concordance matrix C.

sizeC= sizeAG(1);
C = cell(sizeC,sizeC,4);

%{
C{i,j,1}: K_p = 0, sum of the weights of the criteria where g(a)>g(b)+q;
C{i,j,2}: K_e = 0,
sum of the weights of the criteria where -q<= g(a)- g(b)<= q;
C{i,j,3}: K_m = 0, sum of the weights of the criteria where g(a)<g(b)+q.
C{i,j,4}= 0: C(a,b), where "a" correpond to prefered alternative.
%}

q = 0; % Limit of indifference.
% The "factor" parameter to calc Concordance matrix elements.
% F=2
F = 1; 

for i=1: sizeC;
    for j=1: sizeC;
        C{i,j,1}= 0 ;
        C{i,j,2}= 0 ;
        C{i,j,3}= 0 ;
        C{i,j,4}= 0 ;
    end
end

% Weight assessment.

for i=1: sizeAG(1) % counter control for prefered alternative.
    for j=1:sizeAG(1) % counter control for alternative under test.
        for k=2: sizeAG(2) % selected column criteria.
            if i~=j
                if AG{i,k}(1)>AG{j,k}(1)+q
                    for m=1: sizeWW(1)
                        if char(WW{m,1})== ...
                        AG.Properties.VariableNames{k};
                            % concordance K element
                            C{i,j,1}=C{i,j,1}+ WW{m,2}(1); 

                        end
                        %
                    end
                end
                if -q <= AG{i,k}(1)- AG{j,k}(1)<=q
                    for m=1: sizeWW(1)
                        if char(WW{m,1})== ...
                        AG.Properties.VariableNames{k};
                            % concordance K element
                            C{i,j,2}=C{i,j,2}+ WW{m,2}(1);  
                        end
                        %
                    end                   
                end
                if AG{i,k}(1)<AG{j,k}(1)+q
                   for m=1: sizeWW(1)
                        if char(WW{m,1})== AG.Properties.VariableNames{k}
                            % concordance K element
                            C{i,j,3}= double(C{i,j,3})+ WW{m,2}(1);
                        end 
                        %
                    end  
                end        
            end  
        end
    end
end

% To complete of C matrix
for i=1: size(C)
    for j=1:size(C)
        C{i,j,4} = ...
            ( double(C{i,j,1}) + double(C{i,j,2})*F )/...
            (  double(C{i,j,1}) + double(C{i,j,2}) + double(C{i,j,3}) );
    end
end

AG.Properties.VariableNames(2)


