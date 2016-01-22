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
        
        delay_frames
        frames
        
        refresh
        rng_init
        probability
        jitter
        mask
        current_state
        freq_values
        cont_values
        step_start
        step_length
        pre_freq_low
        pre_freq_mid
        freq_frames
        mid_freq_cont
        cont_frames
        post_cont_mid
        post_cont_low
        
        
    end			% properties block
    
    properties(Constant)
        run_script = 'Run_OnTheFly(stimulus, trigger_interval);';
        make_frame_script = ['img_frame = Get_Chirp_Frame(i, stimulus.span_width, stimulus.span_height,  stimulus.freq_values, stimulus.cont_values, stimulus.step_start, stimulus.step_length,stimulus.pre_freq_low,stimulus.pre_freq_mid, stimulus.freq_frames,stimulus.mid_freq_cont, stimulus.cont_frames, stimulus.post_cont_mid, stimulus.post_cont_low);'];
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
            addParameter(p,'delay_frames', def_params.delay_frames);
            addParameter(p,'frames', intmax('int64')); % def max
            addParameter(p,'interval', 1); % def 1
            addParameter(p,'probability', 1.0); % def probability 1
            addParameter(p,'jitter', 0); % def no jitter
            addParameter(p,'binary', 1); % def BW
            addParameter(p,'mask', 0); % 0 if no mask
            addParameter(p,'current_state', 0); % 0 test
            addParameter(p,'freq_values', 0); % 0 test
            addParameter(p,'cont_values', 0); % 0 test\
             addParameter(p,'step_start', 0); % 0 test
              addParameter(p,'step_length', 0); % 0 test
               addParameter(p,'pre_freq_low', 0); % 0 test
                addParameter(p,'pre_freq_mid', 0); % 0 test
                 addParameter(p,'freq_frames', 0); % 0 test
                  addParameter(p,'mid_freq_cont', 0); % 0 test
            addParameter(p,'cont_frames', 0); % 0 test
             addParameter(p,'post_cont_mid', 0); % 0 test
              addParameter(p,'post_cont_low', 0); % 0 test
     
            
            addParameter(p,'rgb', []);  % forced
            addParameter(p,'independent', []);
            addParameter(p,'field_width', []); % forced
            addParameter(p,'field_height', []); % forced
            addParameter(p,'stixel_width', []); % forced
            addParameter(p,'stixel_height', []); % forced
            addParameter(p,'seed', []);  % forced
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
            
            
            stimulus.current_state = 0;
            t_freq = linspace(0,parameters.freq_frames/120, parameters.freq_frames);
            frame_values = 30+30*sin(pi*(t_freq.^2+t_freq/10));
            frame_values = frame_values*(255-0)./(max(frame_values)+min(frame_values));
            stimulus.freq_values = frame_values;
            
            t_cont = linspace(0,parameters.cont_frames/120, parameters.cont_frames);
            contrast_values = 30+3.81*t_cont.*cos(4*pi*t_cont);
            contrast_values = contrast_values*(255-0)./(max(contrast_values)+min(contrast_values));
            stimulus.cont_values = contrast_values;

             stimulus.step_start = parameters.step_start;
        stimulus.step_length =parameters.step_length;
        stimulus.pre_freq_low=parameters.pre_freq_low;
        stimulus.pre_freq_mid=parameters.pre_freq_mid;
        stimulus.freq_frames=parameters.freq_frames;
        stimulus.mid_freq_cont=parameters.mid_freq_cont;
        stimulus.cont_frames=parameters.cont_frames;
        stimulus.post_cont_mid=parameters.post_cont_mid;
       stimulus.post_cont_low=parameters.post_cont_low;
            
            % noise type
            % 0 - binary BW; n_bits = 1
            % 1 - binary RGB; n_bits = 3
            % 2 - gaussian BW; n_bits = 8 (1 draw)
            % 3 - gaussian RGB; n_bits = 8 (3 draws)
            if parameters.binary % binary
                if parameters.independent % RGB
                    stimulus.noise_type = 1;
                    stimulus.n_bits = 3;
                    tmp = [ 1 1 1;  1 1 -1;  1 -1 1;  1 -1 -1;...
                        -1 1 1;  -1 1 -1;  -1 -1 1;  -1 -1 -1];
                    tmp = tmp .* repmat(rgb_vect,8,1)  + repmat(stimulus.back_rgb,8,1);
                else % BW
                    stimulus.noise_type = 0;
                    stimulus.n_bits = 1;
                    tmp = [1 1 1; -1 -1 -1] .* repmat(rgb_vect,2,1)  + repmat(stimulus.back_rgb,2,1);
                end
            else % gaussian
                if parameters.independent % RGB
                    stimulus.noise_type = 3;
                else % BW
                    stimulus.noise_type = 2;
                end
                stimulus.n_bits = 8;
                tmp = norminv((1:256)/257, 0, 1)';
                tmp = repmat(tmp,1,3) .* repmat(rgb_vect,256,1)  + repmat(stimulus.back_rgb, 256, 1);
            end
            
            tmp = uint8(round(255 * tmp))';
            stimulus.lut = tmp(:);
            stimulus.map_back_rgb = uint8( round( 255 * stimulus.back_rgb'));
            
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
            stimulus.stixel_width = parameters.stixel_width;
            stimulus.stixel_height = parameters.stixel_height;
            stimulus.span_width = stimulus.field_width * parameters.stixel_width;
            stimulus.span_height = stimulus.field_height * parameters.stixel_height;
            
            if stimulus.span_width ~= parameters.x_end - parameters.x_start+1 ||...
                    stimulus.span_height ~= parameters.y_end - parameters.y_start +1
                fprintf('\n\nCheck size parameters!!\n');
                stimulus.class = 'f';
                return
            end
            
            stimulus.probability = parameters.probability;
            stimulus.jitter.flag = parameters.jitter;
            stimulus.jitter.state = [];
            %
            if stimulus.jitter.flag
                stimulus.span_width = stimulus.span_width + 2*parameters.stixel_width;
                stimulus.span_height = stimulus.span_height + 2*parameters.stixel_height;
                stimulus.x_start = parameters.x_start-parameters.stixel_width;
                stimulus.y_start = parameters.y_start-parameters.stixel_height;
            end
            
            % mask
            if length(parameters.mask)>1
                stimulus.mask.flag = 1;
                stimulus.mask.mask = parameters.mask;
            else
                stimulus.mask.flag = 0;
            end
            
            % duration, interval, seed
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
            stimulus.refresh = parameters.interval;
            stimulus.rng_init.state = parameters.seed;
            stimulus.rng_init.seed = parameters.seed;
            
        end		% constructor
        
    end			% methods block
end             % Random Noise classdef
