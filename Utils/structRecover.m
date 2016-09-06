function s = structRecover(CellArray) 

% takes a cell array{'fieldname1',value1,...'fieldnameN',valueN} and makes a structure
% JC 7/29/2016

s = struct ;
for a=1:2:length(CellArray) ; % for each element of the structure
    s=setfield(s,CellArray{a},CellArray{a+1}) ;
end
    