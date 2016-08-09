function path2file = write_s_file(parameters, variable_parameters)

% ask user to specify name and path of s-file
[file,path] = uiputfile('*.txt','Save Stimulus As');

if file ~= 0

    path2file = fullfile(path, file);
    fid = fopen(path2file, 'w');
    
    plist = make_plist(parameters);
    fprintf(fid, '%s\r\n', plist);
    for i = 1:length(variable_parameters)
        plist = make_plist(variable_parameters(i));
        fprintf(fid, '%s\r\n', plist);
    end
    
    fclose(fid);    
    save(path2file(1:end-4), 'parameters', 'variable_parameters')
    
end

    function plist = make_plist(params)
        
        names = fieldnames(params);
        plist = '(';
        add_space = '';
        for current_name=1:length(names)
            key = names{current_name};
            val = params.(key);            
            if strcmp(key, 'class') || strcmp(key, 'spatial_modulation') || ...
                    strcmp(key, 'temporal_modulation')
                prefix = ' :';
                suffix = '';
            elseif ischar(val) % map path
                prefix = ' "';
                suffix = '"';
            elseif length(val)>1
                prefix = ' #(';
                suffix = ')';
            else
                prefix = ' ';
                suffix = '';
            end
            if current_name>1
                add_space = ' ';
            end
            val = num2str(val);
            while ~isempty(strfind(val,'  '))
                val = strrep(val, '  ', ' ');
            end
            plist = [plist add_space ':' key prefix val suffix];
        end
        plist = [plist ')'];
        
    end
end
