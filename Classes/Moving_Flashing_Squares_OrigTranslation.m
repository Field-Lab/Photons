classdef Moving_Flashing_Squares_OrigTranslation < handle
    %edited for use in Photons from Xaoyang's RSM code 'Moving_Flashing_Squares.m'
    % JC 7/27/2016
    
    properties
        stim_name
        parameters
        class
        
        run_date_time
        run_time_total
        tmain0
        trep0
        
        main_trigger
        rep_trigger
        
        run_script
        
        field_width
        field_height
        stixel_width
        stixel_height
        
        x_start
        x_end
        y_start
        y_end
        
        wait_key
        wait_trigger
        
        repeats
        num_reps
        
        repeat_num
        
        backgrndcolor
        color
        
        sub_region
       
        frames
        
        trial_num
        trial_num_total
        
        run_duration
        reps_run
        
        seq
        
    end       % properties block
    
    methods
        
        function stimulus = Moving_Flashing_Squares(def_params, parameters)
            
            p = inputParser;
            addParameter(p,'class', 'MFS'); 
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);
            addParameter(p,'field_width', 0); % def 0
            addParameter(p,'field_height',0); % 
            addParameter(p,'stixel_width',0); % 
            addParameter(p,'stixel_height',0); % 
            addParameter(p,'num_reps',0); % 
            addParameter(p,'repeats',0); % 
            addParameter(p,'wait_trigger',0); % 
            addParameter(p,'wait_key',0); % 
            addParameter(p,'sub_region',[]); % 
            addParameter(p,'delay_frames', def_params.delay_frames);  
            
            addParameter(p,'frames', []); % forced
            addParameter(p,'rgb', []); % forced
                       
            parse(p,parameters{:});
            parameters = p.Results;
            
            empty_params = structfun(@(x) isempty(x),parameters);
            tmp = fieldnames(parameters);
            for i = find(empty_params)'
                fprintf('Specify %s\n', tmp{i});
            end
            if ~isempty(find(empty_params, 1))
                stimulus.class = 'f';
                return
            end
                     
            
            if (isfield(parameters,'x_start'))
                if (isfield(parameters,'x_end'))
                    % flip around if needed for proper ordering
                    if (parameters.x_start > parameters.x_end)
                        temp = parameters.x_start;
                        parameters.x_start = parameters.x_end;
                        parameters.x_end = temp;
                        clear temp
                    end
                    
                    stimulus.x_start = parameters.x_start;
                    stimulus.x_end = parameters.x_end;
                    
                else
                    fprintf('\t RSM ERROR: x-end not recognized. Please define x_end value and try again. \n');
                    return
                end  
            else
                fprintf('\t RSM ERROR: x-start recognized. Please define x_start value and try again. \n');
                return
            end  
        
        
            if (isfield(parameters,'y_start'))
                if (isfield(parameters,'y_end'))
                    % flip around if needed for proper ordering
                    if (parameters.y_start > parameters.y_end)
                        temp = parameters.y_start;
                        parameters.y_start = parameters.y_end;
                        parameters.y_end = temp;
                        clear temp
                    end
                    
                    stimulus.y_start = parameters.y_start;
                    stimulus.y_end = parameters.y_end;
                    
                else
                    fprintf('\t RSM ERROR: y-end not recognized. Please define y_end value and try again. \n');
                    return
                end  
            else
                fprintf('\t RSM ERROR: y-start recognized. Please define y_start value and try again. \n');
                return
            end
            
            if (isfield(parameters,'stixel_width'))
                if (isfield(parameters,'stixel_height'))
                   if (isfield(parameters,'field_width'))    
                       if (isfield(parameters,'field_height'))
                           
                           % Check for validity of stixel setup
                            if ((parameters.stixel_width * parameters.field_width) ~= (parameters.x_end - parameters.x_start))
                                fprintf('\t RSM ERROR: Stimulus width inconsistant. Please redfine stixel_width/field_width and/or x_start/x_end and try again. \n');
                                return
                            end
                            
                            if ((parameters.stixel_height * parameters.field_height) ~= (parameters.y_end - parameters.y_start)) 
                                fprintf('\t RSM ERROR: Stimulus height inconsistant. Please redfine stixel_height/field_height and/or y_start/y_end and try again. \n');
                                return
                            end
    
                            stimulus.stixel_width = parameters.stixel_width;            
                            stimulus.stixel_height = parameters.stixel_height;            
                            stimulus.field_width = parameters.field_width;
                            stimulus.field_height = parameters.field_height;
                       
                       else
                           fprintf('\t RSM ERROR: height in stixels ("field_height") not recognized. Please define field_height and try again. \n');
                           return
                       end
                   else
                       fprintf('\t RSM ERROR: width in stixels ("field_width") not recognized. Please define field_width and try again. \n');
                       return
                   end
                else
                   fprintf('\t RSM ERROR: stixel height in pixels ("stixel_height") not recognized. Please define stixel_height value and try again. \n');
                   return
                end 
            else
                fprintf('\t RSM ERROR: stixel width in pixels ("stixel_width") not recognized. Please define stixel_width value and try again. \n');
                return
            end
            
            if (isfield(parameters, 'frames'))
                if (isfield(parameters, 'num_reps'))
                    if (isfield(parameters, 'repeats'))
                        stimulus.repeats = parameters.repeats;
                        stimulus.num_reps = parameters.num_reps;
                        stimulus.frames = parameters.frames;
                    else
                       fprintf('\t RSM ERROR: repeats not recognized. Please define repeats and try again. \n');
                       return
                    end 
                else
                   fprintf('\t RSM ERROR: num_reps not recognized. Please define num_reps and try again. \n');
                   return
                end
            else
               fprintf('\t RSM ERROR: frames not recognized. Please define frames and try again. \n');
               return
            end

            if (isfield(parameters,'rgb'))
                stimulus.color = [parameters.rgb(1); parameters.rgb(2); parameters.rgb(3)];   
                stimulus.color = Color_Test( stimulus.color );
            else
                fprintf('\t RSM ERROR: rgb not recognized. Please define rgb value and try again. \n');
                return
            end
        
            if (isfield(parameters,'back_rgb'))
                stimulus.backgrndcolor = [parameters.back_rgb(1); parameters.back_rgb(2); parameters.back_rgb(3)]; 
                stimulus.backgrndcolor = Color_Test( stimulus.backgrndcolor );
            else
                fprintf('\t RSM ERROR: background rgb not recognized. Please define backgrndcolor value and try again. \n');
                return
            end
            
            if (isfield(parameters,'sub_region'))
                stimulus.sub_region = parameters.sub_region;
            else
                stimulus.sub_region = 0;
            end
            
            stimulus.wait_trigger = parameters.wait_trigger;                            
            stimulus.wait_key = parameters.wait_key;
            
            stimulus.stim_name = 'Moving Flashing Squares';
            stimulus.run_script = 'Run_Moving_Flashing_Squares( stimulus );';
            
            if stimulus.sub_region == 1
                % check if field_width/field_height is even
                if mod(stimulus.field_width, 2) ~= 0 || mod(stimulus.field_height, 2) ~= 0
                    fprintf('\t RSM ERROR: field_width or field height is not even. Please define field_width/field_height value and try again. \n');
                    return
                else
                    stimulus.trial_num = stimulus.field_width * stimulus.field_height / 4;
                end
            elseif stimulus.sub_region == 0;
                stimulus.trial_num = stimulus.field_width * stimulus.field_height;
            else
                fprintf('\t RSM ERROR: sub_region must be 1 or 0. Please define sub_region value and try again. \n');
                return
            end

            stimulus.trial_num_total = stimulus.trial_num * stimulus.repeats;
            
            stimulus.reps_run = 1;
            
            sequence = [];
            for i = 1:stimulus.repeats
                sequence = [sequence; randperm(stimulus.trial_num)];
            end

%             sequence(1, :) = 1:stimulus.trial_num;
            sequence = reshape(sequence', 1, stimulus.trial_num_total);
            stimulus.seq = sequence;
            stim_out = parameters;
            stim_out.trial_list = sequence;
            uisave('stim_out')
        end
        
        
        function time_stamps = Run_Moving_Flashing_Squares( stimulus )
            
           time_stamps = nans(1) ; % temp
            
            x_vertices_all = cell(stimulus.trial_num, 1);
            y_vertices_all = cell(stimulus.trial_num, 1);
            
            if stimulus.sub_region == 0
                for i = 1:stimulus.trial_num
                    xi = floor(mod(i-0.5, stimulus.field_width));
                    yi = floor((i-0.5)/stimulus.field_width);
                    x1 = stimulus.x_start + stimulus.stixel_width * xi;
                    x2 = stimulus.x_start + stimulus.stixel_width * (xi + 1);
                    y1 = stimulus.y_start + stimulus.stixel_height * yi;
                    y2 = stimulus.y_start + stimulus.stixel_height * (yi + 1);

                    x_vertices_all{i} = [x1; x2; x2; x1];
                    y_vertices_all{i} = [y1; y1; y2; y2];
                end
            else
                for i = 1:stimulus.trial_num
                    xi = floor(mod(i-0.5, stimulus.field_width/2));
                    yi = floor((i-0.5)/(stimulus.field_width/2));
                    x1 = stimulus.x_start + stimulus.stixel_width * xi;
                    x2 = stimulus.x_start + stimulus.stixel_width * (xi + 1);
                    y1 = stimulus.y_start + stimulus.stixel_height * yi;
                    y2 = stimulus.y_start + stimulus.stixel_height * (yi + 1);
                    
                    x_vertexi = [x1; x2; x2; x1];
                    y_vertexi = [y1; y1; y2; y2];
                    
                    half_width = (stimulus.x_end - stimulus.x_start)/2;
                    half_height = (stimulus.y_end - stimulus.y_start)/2;

                    x_vertices_all{i} = [x_vertexi x_vertexi+half_width x_vertexi+half_width x_vertexi];
                    y_vertices_all{i} = [y_vertexi y_vertexi y_vertexi+half_height y_vertexi+half_height];
                end
            end
            
            mglClearScreen( stimulus.backgrndcolor );
            mglFlush();
            
            for i = 1:stimulus.trial_num_total
                
                x_vertices = x_vertices_all{stimulus.seq(i)};
                y_vertices = y_vertices_all{stimulus.seq(i)};
                
                cl = repmat(stimulus.color, 1, size(x_vertices, 2));
                bgrd_cl = repmat(stimulus.backgrndcolor, 1, size(x_vertices, 2));
                
                for j = 1:stimulus.num_reps
                    % First phase: turn on colored flash.
                    mglQuad(x_vertices, y_vertices, cl, 0); 

                    mglFlush();
                    Pulse_DigOut_Channel;

                    % Now make sure the second buffer is loaded with the
                    % fore-ground
                    mglQuad(x_vertices, y_vertices, cl, 0);  
                    mglFlush();

                    RSM_Pause(stimulus.frames-1); 


                    % Now the second phase of the cycle, return to background
                    mglQuad(x_vertices, y_vertices, bgrd_cl, 0); 

                    mglFlush();
                    Pulse_DigOut_Channel;

                    % Now make sure the second buffer is loaded with the
                    % background
                    mglQuad(x_vertices, y_vertices, bgrd_cl, 0);  
                    mglFlush();

                    RSM_Pause(stimulus.frames-1);
                end
                
            end
            
        end  % run moving flash squares
        
    end  % method block
                
end   % class def