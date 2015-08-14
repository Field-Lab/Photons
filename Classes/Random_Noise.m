% Random_Noise: Present on-the-fly random noise parameters.
%
%        $Id: Random_Noise VER_ID DATA-TIME vinje $
%      usage: NAME(Args)
%         by: william vinje
%       date: Date
%  copyright: (c) Date William Vinje, Eduardo Jose Chichilnisky (GPL see RSM/COPYING)


classdef	Random_Noise < handle
    
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
        
        
    end			% properties block
    
    properties(Constant)
        run_script = 'Run_OnTheFly(stimulus, trigger_interval);';
        make_frame_script = ['img_frame = Draw_Random_Frame_opt(stimulus.rng_init.state,' ...
            'stimulus.field_width, stimulus.field_height, stimulus.lut, '...
            'stimulus.map, stimulus.map_back_rgb, stimulus.m_width, stimulus.m_height, ',...
            'stimulus.noise_type, stimulus.n_bits, stimulus.probability);'];
    end
    
    methods
        
        function stimulus = Random_Noise(def_params, parameters)
            
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
            
            % duration, interval, seed
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
            stimulus.refresh = parameters.interval;
            stimulus.rng_init.state = parameters.seed;
                        
        end		% constructor
       
    end			% methods block
end             % Random Noise classdef