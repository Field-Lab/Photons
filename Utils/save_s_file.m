function [] = save_s_file(parameters, stim, seq)

% ask user to specify name and path of s-file
current_path = pwd;
[file,path] = uiputfile('*.txt','Save Stimulus As');

if file ~= 0
    cd(path)

    % create txt file
    fid = fopen(file, 'w');


    if strcmp(parameters.class, 'MG')
        % write def_params into s-file
        if strcmp(parameters.spatial_modulation, 'square')
            stim_type = 'DRIFTING-SQUAREWAVE';
        elseif strcmp(parameters.spatial_modulation, 'sine')
            stim_type = 'DRIFTING-SINUSOID';
        end
        formatSpec = '(:TYPE :%s :RGB #(%.2f %.2f %.2f) :BACK-RGB #(%.2f %.2f %.2f) :X-START %.0f :X-END %.0f :Y-START %.0f :Y-END %.0f :FRAMES %.0f) ';
        fprintf(fid, formatSpec,stim_type, parameters.rgb(1), parameters.rgb(2),...
            parameters.rgb(3), parameters.back_rgb(1), parameters.back_rgb(2), ...
            parameters.back_rgb(3), parameters.x_start, parameters.x_end, ...
            parameters.y_start, parameters.y_end, parameters.frames);

        % write stim parameters into s-file
        formatSpec = '(:SPATIAL-PERIOD %.0f :TEMPORAL-PERIOD %.0f :DIRECTION %.0f) ';
        for i = 1:length(stim)
            fprintf(fid, formatSpec, stim(i).spatial_period, stim(i).temporal_period, stim(i).direction);
        end

    elseif strcmp(parameters.class, 'CG')
        if strcmp(parameters.spatial_modulation, 'square')
            if strcmp(parameters.temporal_modulation, 'square')
                stim_type = 'REVERSING-SQUAREWAVE-SQUAREWAVE';
            elseif strcmp(parameters.temporal_modulation, 'sine')
                stim_type = 'REVERSING-SQUAREWAVE-SINUSOID';
            else
                fprintf('\t ERROR: temporal_modulation not recognized. Please define temporal_modulation and try again. \n');
            end
        elseif strcmp(parameters.spatial_modulation, 'sine')
            if strcmp(parameters.temporal_modulation, 'square')
                stim_type = 'REVERSING-SINUSOID-SQUAREWAVE';
            elseif strcmp(parameters.temporal_modulation, 'sine')
                stim_type = 'REVERSING-SINUSOID-SINUSOID';
            else
                fprintf('\t ERROR: temporal_modulation not recognized. Please define temporal_modulation and try again. \n');
            end
        else
            fprintf('\t ERROR: spatial_modulation not recognized. Please define spatial_modulation and try again. \n');
        end
        formatSpec = '(:TYPE :%s :RGB #(%.2f %.2f %.2f) :BACK-RGB #(%.2f %.2f %.2f) :X-START %.0f :X-END %.0f :Y-START %.0f :Y-END %.0f :FRAMES %.0f) ';
        fprintf(fid, formatSpec,stim_type, parameters.rgb(1), parameters.rgb(2),...
            parameters.rgb(3), parameters.back_rgb(1), parameters.back_rgb(2), ...
            parameters.back_rgb(3), parameters.x_start, parameters.x_end, ...
            parameters.y_start, parameters.y_end, parameters.frames);

        % write stim parameters into s-file
        formatSpec = '(:SPATIAL-PERIOD %.0f :TEMPORAL-PERIOD %.0f :SPATIAL-PHASE %.0f :ORIENTATION %.0f) ';
        for i = 1:length(stim)
            fprintf(fid, formatSpec, stim(i).spatial_period, stim(i).temporal_period, stim(i).spatial_phase, stim(i).orientation);
        end


    elseif strcmp(parameters.class, 'MB')
        stim_type = 'MOVING-BAR';
        formatSpec = '(:TYPE :%s :RGB #(%.2f %.2f %.2f) :BACK-RGB #(%.2f %.2f %.2f) :X-START %.0f :X-END %.0f :Y-START %.0f :Y-END %.0f :DELAY-FRAMES %.0f) ';
        fprintf(fid, formatSpec,stim_type, parameters.rgb(1), parameters.rgb(2),...
            parameters.rgb(3), parameters.back_rgb(1), parameters.back_rgb(2), ...
            parameters.back_rgb(3), parameters.x_start, parameters.x_end, ...
            parameters.y_start, parameters.y_end, parameters.delay_frames);

        % write stim parameters into s-file
        formatSpec = '(:BAR-WIDTH %.0f :DELTA %.0f :DIRECTION %.0f :FRAMES %.0f) ';
        for i = 1:length(stim)
            fprintf(fid, formatSpec, stim(i).bar_width, stim(i).delta, stim(i).direction, stim(i).frames);
        end
    else
        fprintf('\t ERROR: class not recognized. Please define class and try again. \n');
    end

    % close s-file
    fclose(fid);
    
    % save .mat file
    stim_out = parameters;
    stim_out.trial_list = seq;
    stim_out.trials = stim;
    mat_file = strread(file, '%s', 'delimiter', '.');
    mat_file = [mat_file{1} '.mat'];
    save(mat_file, 'stim_out')
    
    
    
    cd(current_path)
end
end
