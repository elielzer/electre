%% Decision Making - ELECTRE 
% Type P.alpha Problem.
% 
%% Data reading step

alternative_criteria = 'CriteriaAlternative.dat' ;
AltCrt = readtable(alternative_criteria) ;
sizeA = size(AltCrt) ;

%%
% |AltCrt|: Problem dataset or alternative-criteria table.
%
% If ordinal dada appears, then a scale will be associated, acording to the
% decision maker's preference.
%
% * 'A': high, higher, big, good, gold, emergency;
% * 'B': intermediate, average, satisfactory, silver, urgency;
% * 'C': low, small, unsatisfactory, bronze, planned.
% * AC: A>C; BC: B>C, AB: A>B, 
% * (A-C)/A = (10-7)/10= 0.3,
% * (B-C)/A =(7-4)/10 = 0.3,
% * (A-B)/A =(10-7)/10 = 0.3

Criteria = 'Criteria.dat' ;
W = readtable(Criteria) ;
%%
% |W|: Assessment dataset.

Thresholds = 'thresholds.dat' ;
T = readtable(Thresholds) ;
%%
% |T|: Thresholds values.

q = 0 ;
%%
% |q|: It is the limit of indifference.
%%
F = 1 ;
% F=2;
%%
% |F|: The "factor" parameter to calc to Concordance matrix elements.
%% Execution of weight normalization.
wsum=0;

for id = 1: size(W,1)
    wsum= wsum + W.Weight(id) ;
end

% Redo weights matrix with normalized weight values.
WW=W;
WW.Weight=(1/wsum)*W.Weight ;
sizeW = size(W) ;
disp(WW)
%%
% |WW|: Copy of |W| table, but with already normalized weights.


%% Concordance matrix C.
% Memory allocation

sizeC= sizeA(1) ;
C = cell(sizeC,sizeC,4) ;

for i=1: sizeC;
    for j=1: sizeC;
        C{i,j,1}= 0 ;
        C{i,j,2}= 0 ;
        C{i,j,3}= 0 ;
        C{i,j,4}= 0 ;
    end
end

%%
% |C{i,j,1}| correponds to K_p, that is, sum of the weights of the
% criteria where g(a)>g(b)+q.
%
% |C{i,j,2}| correponds to K_e, that is, sum of the weights of the
% criteria where g(a)<g(b)+q.
%
% |C{i,j,3}| correponds to K_m, that is, sum of the weights of the
% riteria where g(a)<g(b)+q.
%
% |C{i,j,4}| effectively correponds to the agreement index in favor of an
% alternative |i| instead of an alterntive |j|.
%
%%
% Weight assessment.

for i=1: sizeA(1) % "i": counter of control for selected column at the
% alternative-criteria table (problem's dataset).

    for j=1:sizeA(1) % "j": counter of control for alternative under test.
        for k=2: sizeA(2) % selected column of criteria at 
        % alternative-criteria table.
            if i~=j
                if iscell(AltCrt{i,k}(1)) % checks the cardinality of the
                % alternative evaluation columns.

                    switch AltCrt{i,k}(1)
                        case {'high', 'higher', 'big',...
                                'good', 'gold', 'emergency'}
                            key1= 'A' ;
                        case {'intermediate', 'average', 'satisfactory',
                                'silver', 'urgency'}
                            key1='B' ;
                        case {'low', 'small', 'unsatisfactory', 'bronze',
                                'planned'}
                            key1='C' ;
                    end 
                    switch AltCrt{j,k}(1)
                        case {'high', 'higher', 'big',...
                                'good', 'gold', 'emergency'}
                            key2= 'A' ;
                        case {'intermediate', 'average', 'satisfactory',
                                'silver', 'urgency'}
                            key2='B' ;
                        case {'low', 'small', 'unsatisfactory', 'bronze',
                                'planned'}
                            key2='C' ;
                    end
                    switch strcat(key1,key2)
                        case {'AC','BC', 'AB' }
                            for m=1: sizeW(1)
                                if char(WW{m,1})== ...
                                AltCrt.Properties.VariableNames{k} ;
                                    % Concordance table's K element.
                                    C{i,j,1}=C{i,j,1}+ WW{m,2}(1) ; 
                                end
                            end
                            %
                        case {'AA','BB', 'CC'}
                            for m=1: sizeW(1)
                                if char(WW{m,1})== ...
                                AltCrt.Properties.VariableNames{k} ;
                                    % Concordance table's K element.
                                    C{i,j,2}=double(C{i,j,2})+ WW{m,2}(1) ;  
                                end
                                %
                            end                            
                            %
                        case {'CA', 'CB', 'BA' }
                        for m=1: sizeW(1)
                            if char(WW{m,1})== ...
                                    AltCrt.Properties.VariableNames{k}
                                % Concordance table's K element.
                                C{i,j,3}= double(C{i,j,3})+ WW{m,2}(1) ;
                            end 
                            %
                       end                           
                    end
                else % Statement not is cell. 
                    if AltCrt{i,k}(1)>AltCrt{j,k}(1)+q
                        for m=1: sizeW(1)
                            if char(WW{m,1})== ...
                            AltCrt.Properties.VariableNames{k} ;
                                % Concordance table's K element.
                                C{i,j,1}=double(C{i,j,1})+ WW{m,2}(1) ; 

                            end
                            %
                        end
                    end
                    if -q <= AltCrt{i,k}(1)- AltCrt{j,k}(1)<=q
                        for m=1: sizeW(1)
                            if char(WW{m,1})== ...
                            AltCrt.Properties.VariableNames{k} ;
                                % Concordance table's K element
                                C{i,j,2}=double(C{i,j,2})+ WW{m,2}(1) ;  
                            end
                            %
                        end
                    end
                    if AltCrt{i,k}(1)<AltCrt{j,k}(1)+q
                       for m=1: sizeW(1)
                            if char(WW{m,1})== ...
                                    AltCrt.Properties.VariableNames{k}
                                % Concordance table's K element
                                C{i,j,3}= double(C{i,j,3})+ WW{m,2}(1) ;
                            end
                       end
                    end
                end
            end
        end
    end
end
%%
% Calculate and store the respective concordance index in matrix C
for i=1: size(C)
    for j=1:size(C)
        if i~=j 
        C{i,j,4} = ...
            ( double(C{i,j,1}) + double(C{i,j,2})*F )/...
            (  double(C{i,j,1}) + double(C{i,j,2}) + double(C{i,j,3}) ) ;
        end
    end
end

%% Normalization of data from the alternative-criteria table.
% Define a secondary table.    

AltCrtNmz = AltCrt ;
%%
for i=1: sizeA(1)
    for j=2: sizeA(2) % Selected column of criteria at
        % alternative-criteria table.
        for m=1: sizeW(1)
            if char(WW{m,1})== ...
            AltCrt.Properties.VariableNames{k} ; 
                AltCrtNmz{i,j}= AltCrtNmz{i,j}/  WW{m,7}(1) ; 
            end
        end            
            
    end
end
%% Discordance matrix D.
% Memory allocation

D = cell(sizeC,sizeC,4) ;
for i=1: sizeC ;
    for j=1: sizeC;
        D{i,j,1}= 0 ;
        D{i,j,2}= 0 ;
        D{i,j,3}= 0 ;
        D{i,j,4}= 0 ;
    end
end

%%
% Resize the |WW| matrix to meet the evaluation value normalization
% process.

WW.A_Max = double(zeros([size(WW,1) 1]) ) ;
%%
% |WW.A_Max|: colunm to receive the maximum value found by criteria column 
% in the alternative_criteria table.

WW.A_Min = double(zeros([size(WW,1) 1]) ) ;
%%
% |WW.A_Min|: column to receive the minimum value found by criteria column
% in the alternative-criteria table.

WW.delta = double(zeros([size(WW,1) 1]) ) ;
%% 
% |WW.delta|: column to receive the delta given by the difference between
% the maximum and minimum column of the |WW| intermediate table.

    for k=1:sizeA(2) % "k": Counter of control for selected column at the 
        % alternative-criteria table. 
        if iscell(AltCrt{1,k}(1)) % Checks the cardinality of the 
        % alternative evaluation columns.
        
        else
           for m=1: sizeW(1)
                if char(WW{m,1})== ...
                        AltCrt.Properties.VariableNames{k}
                    WW{m,5}= double(max(AltCrt{:,k},[],1)) ;
                    WW{m,6}= double(min(AltCrt{:,k},[],1)) ;
                    WW{m,7}= double(WW{m,5} - WW{m,6}) ;
                end 
           end             
        end
    end






