function parameters = combine_parameters(varargin)

parameters = []; total_length = 0;
for i = 1:nargin
    tmp = fieldnames(varargin{i});
    total_length = total_length + length(tmp);
    for j=1:length(tmp)
        parameters.(tmp{j}) = varargin{i}.(tmp{j});
    end
end

if total_length > length(fieldnames(parameters))
    fprintf('\n\nDOUBLE PARAMETERS\n\n')
end

if isfield(parameters, 'rgbs')
    tmp = parameters.rgbs;    
    V = [size(tmp{1}), 1]; V(find(V == 1, 1)) = numel(tmp);
    parameters.rgb = cell2mat(reshape(horzcat(tmp{:}), V));
    parameters = rmfield(parameters, 'rgbs');
end

if isfield(parameters, 'rgb') && iscell(parameters.rgb) % moving bars
    parameters.rgb = cell2mat(parameters.rgb);
end

if isfield(parameters, 'x_delta') % moving bars
    parameters.delta = parameters.x_delta;
    parameters = rmfield(parameters, 'x_delta');
end

if isfield(parameters, 'direction') % for gratings?
    parameters.orientation = parameters.direction;
    parameters = rmfield(parameters, 'direction');
end

if isfield(parameters, 'filter_scale')  % moving bars
    parameters = rmfield(parameters, 'filter_scale');
end

if isfield(parameters, 'type') % from old s file format
    parameters = rmfield(parameters, 'type');
end

if isfield(parameters, 'index_map') % from old s file format
    parameters = rmfield(parameters, 'index_map');
end
