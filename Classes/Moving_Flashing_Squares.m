classdef Moving_Flashing_Squares < handle
    %edited for use in Photons from Xaoyang's RSM code 'Moving_Flashing_Squares.m'
    % added ability to flash squares in overlapping regions
    % JC 7/27/2016
    
    properties
        stim_name
        parameters
        class

        run_script

        stixel_width % (pix) width of square
        stixel_shift % (pix) how much square will shift
        
        x_start
        x_end
        y_start
        y_end
        
        field_width
        field_height
        shiftFactor
        
        wait_key
        wait_trigger
        
        repeats
        num_reps
        random_seq
        
        backgrndcolor
        color
        
        sub_region
       
        frames
        
        trial_num
        trial_num_total
        trial_list
        
        total_frame_num % number of frames of the entire stim
        
        x_vertices_all
        y_vertices_all
        
    end       % properties block
    
    methods
        
        function stimulus = Moving_Flashing_Squares(~, parameters)
            
            % make parameters array from make_stimulus into structure
            parameters = structRecover(parameters) ;
                     
            % check that all the necessary fields are present and put into stimulus structure
            try
                stimulus.x_start = parameters.x_start;
                stimulus.x_end = parameters.x_end;
                stimulus.y_start = parameters.y_start;
                stimulus.y_end = parameters.y_end;     
                stimulus.stixel_width = parameters.stixel_width;            
                stimulus.stixel_shift = parameters.stixel_shift;
                stimulus.repeats = parameters.repeats;
                stimulus.num_reps = parameters.num_reps;
                stimulus.frames = parameters.frames;
                %stimulus.color = [parameters.rgb(1); parameters.rgb(2); parameters.rgb(3)];   
                stimulus.color = [parameters.rgb+parameters.back_rgb]';
                %stimulus.color = Color_Test( stimulus.color );
                stimulus.backgrndcolor = parameters.back_rgb;
                stimulus.sub_region = parameters.sub_region ;
                stimulus.wait_trigger = parameters.wait_trigger;                            
                stimulus.wait_key = parameters.wait_key;
                stimulus.stim_name = 'Moving Flashing Squares';
                stimulus.run_script = 'Run_Moving_Flashing_Squares( stimulus );';
            catch
                fprintf('\t ERROR: undefined parameter \n');
                return
            end  
        
            % calculate number of stixels
            stimulus.field_width = (parameters.x_end-parameters.x_start)/stimulus.stixel_width ;
            stimulus.field_height = (parameters.y_end-parameters.y_start)/stimulus.stixel_width ;
            stimulus.shiftFactor = stimulus.stixel_width/stimulus.stixel_shift ;
            
            % check validity of stixel_shift and stixel_width
            if rem(stimulus.stixel_width,stimulus.stixel_shift)~=0 ;
                fprintf('\t ERROR: stixel width must be divisible by shift \n');
                return
            end
            
            % check validity of field width/height 
            if mod(stimulus.field_width,1)~=0  || ...
                   mod(stimulus.field_width,1)~=0 ;
                fprintf('\t ERROR: field width must be divisable by stixel width \n');
                return
            end
                
            % determine trial_number 
            if stimulus.sub_region == 1
                % check if field_width/field_height is even
                if mod(stimulus.field_width, 2) ~= 0 || mod(stimulus.field_height, 2) ~= 0
                    fprintf('\t RSM ERROR: field_width or field height is not even. \n');
                    return
                else
                    stimulus.trial_num = stimulus.field_width * stimulus.field_height * stimulus.shiftFactor^2 / 4;
                end
            elseif stimulus.sub_region == 0;
                stimulus.trial_num = stimulus.field_width * stimulus.field_height * stimulus.shiftFactor^2;
            else
                fprintf('\t RSM ERROR: sub_region must be 1 or 0. Please define sub_region value and try again. \n');
                return
            end

            stimulus.trial_num_total = stimulus.trial_num * stimulus.repeats;
            
            % find square verticies
            stimulus.x_vertices_all = cell(stimulus.trial_num, 1);
            stimulus.y_vertices_all = cell(stimulus.trial_num, 1);
            
            if stimulus.sub_region == 0
                i=1 ;
                for a=1:stimulus.field_width ; % for each row x 
                    for b=1:stimulus.field_height ; % for each column y 
                        for c=1:stimulus.shiftFactor ; % for each shift along x
                            for d=1:stimulus.shiftFactor ; % for each shift along y
                                x1 = stimulus.x_start + stimulus.stixel_shift*(c-1) + stimulus.stixel_width*(a-1) ;
                                x2 = stimulus.x_start + stimulus.stixel_shift*(c-1) + stimulus.stixel_width*(a) ;
                                y1 = stimulus.y_start + stimulus.stixel_shift*(d-1) + stimulus.stixel_width*(b-1) ;
                                y2 = stimulus.y_start + stimulus.stixel_shift*(d-1) + stimulus.stixel_width*(b) ;

                                stimulus.x_vertices_all{i} = [x1; x2; x2; x1];
                                stimulus.y_vertices_all{i} = [y1; y1; y2; y2];
                                i=i+1 ;
                            end
                        end
                    end
                end
            else
                i=1 ;
                for a=1:stimulus.field_width/2 ; % logic as above but half the columns and rows
                    for b=1:stimulus.field_height/2 ; 
                        for c=1:stimulus.shiftFactor ;
                            for d=1:stimulus.shiftFactor ;
                                x1 = stimulus.x_start + stimulus.stixel_shift*(c-1) + stimulus.stixel_width*(a-1) ;
                                x2 = stimulus.x_start + stimulus.stixel_shift*(c-1) + stimulus.stixel_width*(a) ;
                                y1 = stimulus.y_start + stimulus.stixel_shift*(d-1) + stimulus.stixel_width*(b-1) ;
                                y2 = stimulus.y_start + stimulus.stixel_shift*(d-1) + stimulus.stixel_width*(b) ;

                                x_vertexi = [x1; x2; x2; x1];
                                y_vertexi = [y1; y1; y2; y2];

                                half_width = (stimulus.x_end - stimulus.x_start)/2; 
                                half_height = (stimulus.y_end - stimulus.y_start)/2;

                                stimulus.x_vertices_all{i} = [x_vertexi x_vertexi+half_width x_vertexi+half_width x_vertexi];
                                stimulus.y_vertices_all{i} = [y_vertexi y_vertexi y_vertexi+half_height y_vertexi+half_height];
                                i=i+1 ;
                            end
                        end
                    end
                end
            end
            
            % sequence of square presentation
            sequence = [];
            for i = 1:stimulus.repeats
                if stimulus.random_seq ;
                    sequence = [sequence; randperm(stimulus.trial_num)];
                else
                    sequence = [sequence; [1:stimulus.trial_num]];
                end
            end
            stimulus.trial_list = reshape(sequence', 1, stimulus.trial_num_total);
            
            % total number of frames that will be shown
            stimulus.total_frame_num = stimulus.trial_num_total*stimulus.num_reps*stimulus.frames*2 ; % each trial has off and on frames
            
            % save important stim params
            stim_out = stimulus;
            uisave('stim_out')
            
            % display number necessary time (s)
            disp(['run time: ', num2str(stimulus.total_frame_num/mglGetParam('frameRate')), 's']) ;   
        end
        
        
        function time_stamps = Run_Moving_Flashing_Squares( stimulus )
            
            time_stamps = nan(1) ; % temp
            
            mglClearScreen( stimulus.backgrndcolor );
            mglFlush();
            mglClearScreen( stimulus.backgrndcolor );
            mglFlush();
            
            for i = 1:stimulus.trial_num_total
                
                x_vertices = stimulus.x_vertices_all{stimulus.trial_list(i)};
                y_vertices = stimulus.y_vertices_all{stimulus.trial_list(i)};
                
                cl = repmat(stimulus.color, 1, size(x_vertices, 2));
                bgrd_cl = repmat(stimulus.backgrndcolor', 1, size(x_vertices, 2));
                
                for j = 1:stimulus.num_reps
                    % display spot (need to load and flush two buffers)
                    mglQuad(x_vertices, y_vertices, cl , 0); 
                    mglFlush(); 
                    mglQuad(x_vertices, y_vertices, cl , 0); 
                    mglFlush();
               
                    Pulse_DigOut_Channel;
                    
                    RSM_Pause(stimulus.frames-1); % hold for 

                    % display background only
                    mglClearScreen( bgrd_cl );
                    mglFlush();
                    mglClearScreen( bgrd_cl );
                    mglFlush();
                    
                    Pulse_DigOut_Channel;

                    RSM_Pause(stimulus.frames-1);
                end
            end            
        end  % run moving flash squares        
    end  % method block                
end   % class def