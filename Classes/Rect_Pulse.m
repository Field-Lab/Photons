classdef	Rect_Pulse < handle
    
    properties
        
        class
        parameters
        
        x_vertices
        y_vertices
        
        rgb
        back_rgb
        
        delay_frames
        frames

    end
    
    properties(Constant)
        run_script = 'Run_Rect_Pulses(stimulus);';
    end
    
    
    methods
        
        % Constructor method
        function stimulus = Rect_Pulse(def_params, parameters)
            
            p = inputParser;
            addParameter(p,'class','FP');            
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);
            addParameter(p,'delay_frames', def_params.delay_frames);
            
            addParameter(p,'rgb', []); % forced
            addParameter(p,'frames', []);  % forced            
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
            
            stimulus.x_vertices = [parameters.x_start; parameters.x_end; parameters.x_end; parameters.x_start];
            stimulus.y_vertices = [parameters.y_end; parameters.y_end; parameters.y_start; parameters.y_start];
            
            stimulus.rgb = (parameters.back_rgb + parameters.rgb)';
            stimulus.back_rgb = parameters.back_rgb;

            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames; 

        end     % constructor methods
    
        function time_stamps = Run_Rect_Pulses(stimulus)
            
            time_stamps = zeros(2,1);
            t0 = mglGetSecs;            
            RSM_Pause(stimulus.delay_frames-1);
            Pulse_DigOut_Channel;
            mglFlush   
            
            mglQuad(stimulus.x_vertices, stimulus.y_vertices, stimulus.rgb, 0);
            mglFlush
            time_stamps(1) = mglGetSecs(t0);
            mglQuad(stimulus.x_vertices, stimulus.y_vertices, stimulus.rgb, 0);
            mglFlush            
            RSM_Pause(stimulus.frames-2); 
            
            Pulse_DigOut_Channel;            
            time_stamps(2) = mglGetSecs(t0);
        end
    end        
end   