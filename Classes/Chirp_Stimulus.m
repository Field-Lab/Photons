%% chirp stimulus

% left a bunch of unnecessary parameters

classdef	Chirp_Stimulus < handle
    
    properties
        
        class
        parameters
        
        lut
        back_rgb
        map_back_rgb
        noise_type
        n_bits
        jitter 
        
        % size
        field_width
        field_height
        stixel_width
        stixel_height
        m_width
        m_height
        x_start
        y_start
        span_width
        span_height
        
        map
        
        
        frames
        
        refresh
        mask
%         current_state
%         freq_values
%         cont_values
%         step_start
%         step_length
%         pre_freq_low
%         pre_freq_mid
%         freq_frames
%         mid_freq_cont
%         cont_frames
%         post_cont_mid
%         post_cont_low
        intensity_values
        
        
        delay_frames
        tail_frames
        
        
    end			% properties block
    
    properties(Constant)
        run_script = 'Run_OnTheFly(stimulus, trigger_interval);';
        make_frame_script = ['img_frame = Get_Chirp_Frame(i, stimulus.span_width, stimulus.span_height,  stimulus.intensity_values);'];
    end
    
    methods
        
        function stimulus = Chirp_Stimulus(def_params, parameters)
            
            p = inputParser;
            addParameter(p,'class','RN');
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);
            addParameter(p,'frames', intmax('int64')); % def max
            addParameter(p,'interval', 1); % def 1
                        addParameter(p,'delay_frames', 0); % def 1

                                    addParameter(p,'tail_frames', 0); % def 1

            addParameter(p,'jitter', 0); % def no jitter
            addParameter(p,'mask', 0); % 0 if no mask
                        addParameter(p,'intensity_values', 0); % 0 if no mask

            addParameter(p,'current_state', 0); % 0 test
%             addParameter(p,'freq_values', 0); % 0 test
%             addParameter(p,'cont_values', 0); % 0 test\
%              addParameter(p,'step_start', 0); % 0 test
%               addParameter(p,'step_length', 0); % 0 test
%                addParameter(p,'pre_freq_low', 0); % 0 test
%                 addParameter(p,'pre_freq_mid', 0); % 0 test
%                  addParameter(p,'freq_frames', 0); % 0 test
%                   addParameter(p,'mid_freq_cont', 0); % 0 test
%             addParameter(p,'cont_frames', 0); % 0 test
%              addParameter(p,'post_cont_mid', 0); % 0 test
%               addParameter(p,'post_cont_low', 0); % 0 test
     
            
            addParameter(p,'rgb', []);  % forced
            addParameter(p,'field_width', []); % forced
            addParameter(p,'field_height', []); % forced
            addParameter(p,'stixel_width', []); % forced
            addParameter(p,'stixel_height', []); % forced
            addParameter(p,'map_file_name', 'dummy');% optional
            
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
            
            stimulus.parameters = parameters;
            stimulus.class = parameters.class;
            
            rgb_vect = parameters.rgb;
            stimulus.back_rgb = parameters.back_rgb;
            
            % equations that define chirp stimulus
            
            
          
            % fork for map-based (voronoi) WN
            if ~strcmp(parameters.map_file_name, 'dummy')
                user_map = load(parameters.map_file_name);
                stimulus.map = uint16( user_map' );
                stimulus.m_width = max(stimulus.map(:));
                stimulus.m_height = 1;
            else
                stimulus.map =[];
                stimulus.m_width = parameters.field_width;
                stimulus.m_height = parameters.field_height;
            end
            
            % size
            stimulus.field_width = parameters.field_width;
            stimulus.field_height = parameters.field_height;
            stimulus.x_start = parameters.x_start;
            stimulus.y_start = parameters.y_start;
            stimulus.span_width = stimulus.field_width * parameters.stixel_width;
            stimulus.span_height = stimulus.field_height * parameters.stixel_height;
            stimulus.intensity_values = parameters.intensity_values;
            if stimulus.span_width ~= parameters.x_end - parameters.x_start+1 ||...
                    stimulus.span_height ~= parameters.y_end - parameters.y_start +1
                fprintf('\n\nCheck size parameters!!\n');
                stimulus.class = 'f';
                return
            end
            
            stimulus.jitter.flag = parameters.jitter;
          
            % mask
            if length(parameters.mask)>1
                stimulus.mask.flag = 1;
                stimulus.mask.mask = parameters.mask;
            else
                stimulus.mask.flag = 0;
            end
            
            % duration, interval, seed
            stimulus.frames = parameters.frames;
            stimulus.refresh = parameters.interval;
                        stimulus.delay_frames = parameters.delay_frames;

                                    stimulus.tail_frames = parameters.tail_frames;

        end		% constructor
        
    end			% methods block
end          
