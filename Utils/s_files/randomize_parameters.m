function parameters = randomize_parameters(varargin)

nrepeats = 1;
cnt = 1;
masked = [];
for i=1:2:nargin
    if ~strcmp(varargin{i}, 'nrepeats')
        names{cnt} = varargin{i};
        params_values{cnt} = varargin{i+1};
        temp_params{cnt} = params_values{cnt};
        if iscell(params_values{cnt})        
            masked = [masked cnt];
            temp_params{cnt} = 1:length(params_values{cnt});
        end
        cnt=cnt+1;
    else
        nrepeats = varargin{i+1};
    end
end

repeated_combos = [];
combos = combvec(temp_params{:});
for i=1:nrepeats
    repeated_combos = [repeated_combos combos(:,randperm(size(combos,2)))];
end
repeated_combos = num2cell(repeated_combos);


parameters = [];
for i=1:size(names,2)
    for j=1:size(repeated_combos,2)
        if ~isempty(find(masked==i,1))
            repeated_combos{i,j} = params_values{i}{repeated_combos{i,j}};
        end
        parameters = setfield(parameters,{j}, names{i}, repeated_combos{i,j});
    end
end
