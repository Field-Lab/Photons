classdef	Map_Pulse < handle
    
    properties
        
        class
        parameters
        
        x_start
        y_start
        x_span
        y_span
        
        back_rgb
              
        delay_frames
        frames

        frametex
        
    end
    
    properties(Constant)
        run_script = 'Run_Map_Pulse(stimulus);';
    end
  
    methods
        
        % Constructor method
        function stimulus = Map_Pulse(def_params, parameters)
            
            p = inputParser;
            addParameter(p,'class','PL');
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);
            addParameter(p,'delay_frames', def_params.delay_frames);

            addParameter(p,'rgb', []);%  forced
            addParameter(p,'frames', []); %  forced            
            addParameter(p,'map_file_name', []); % forced
                       
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
            
            stimulus.x_start = parameters.x_start;
            stimulus.y_start = parameters.y_start;
            stimulus.x_span = parameters.x_end - parameters.x_start;
            stimulus.y_span = parameters.y_end - parameters.y_start;
            
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
            
            back_rgb_full = repmat(parameters.back_rgb, size(parameters.rgb,1),1);
            rgb = uint8( round( 255*(back_rgb_full + parameters.rgb)));
            stimulus.back_rgb = parameters.back_rgb;
            

            map = load(parameters.map_file_name);
            map = uint8(map);
            map = map';  % NB: The transposing of the matrix was estabilished by comparison to the older style code that read in the
            % map to build up the image mat within matlab.
            
            image_mat = Make_Map(size(map,1), size(map,2), rgb, map, uint8( round( 255 * stimulus.back_rgb')));
            stimulus.frametex = mglCreateTexture(image_mat);

        end     % constructor methods
        
        
        function time_stamps = Run_Map_Pulse(stimulus)
            
            time_stamps = zeros(2,1);
            t0 = mglGetSecs;            
            RSM_Pause(stimulus.delay_frames);
            Pulse_DigOut_Channel;
            mglClearScreen;
            mglFlush
            
            mglBltTexture(stimulus.frametex, [stimulus.x_start, stimulus.y_start, stimulus.x_span, stimulus.y_span], -1,-1 );   % top left
            mglFlush
            
            time_stamps(1) = mglGetSecs(t0); % when first stimulus frame came on            
            mglBltTexture(stimulus.frametex, [stimulus.x_start, stimulus.y_start, stimulus.x_span, stimulus.y_span], -1,-1 );   % top left
            mglFlush          
            RSM_Pause(stimulus.frames-2); 
            
            Pulse_DigOut_Channel;            
            time_stamps(2) = mglGetSecs(t0);
        end     
    end    
end  